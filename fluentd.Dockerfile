FROM fluent/fluentd:v1.12-debian-1

USER root

LABEL "com.centurylinklabs.watchtower"="false"

RUN fluent-gem install fluent-plugin-newrelic
