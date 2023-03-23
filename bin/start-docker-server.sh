#!/bin/bash

set -e

# Prune docker.
docker system prune -a -f

# Takes production env as argument
export PRODUCTION_ENV=$1

# Load the relevant docker-compose env file for the PRODUCTION_ENV
if [ -f .env.docker-compose.$1 ]; then
    # Load Environment Variables
    export $(cat .env.docker-compose.$1 | grep -v '#' | awk '/=/ {print $1}')
fi

# Create a new docker compose file for the server.
cp ./docker-compose.template.yml ./docker-compose.server.yml

# Replace all the instances of env var placeholders in the new docker compose.
envsubst < "./docker-compose.template.yml" > "./docker-compose.server.yml"

# Restart all the docker containers.
docker-compose -f docker-compose.server.yml -p orders-portal --compatibility down
docker-compose -f docker-compose.server.yml -p orders-portal --compatibility build
docker-compose -f docker-compose.server.yml -p orders-portal --compatibility up -d
