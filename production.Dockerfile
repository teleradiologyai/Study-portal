FROM ruby:2.6-alpine as production

WORKDIR /app

COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  postgresql-client \
  shared-mime-info \
  && rm -rf /var/cache/apk/*

# Use libxml2, libxslt a packages from alpine for building nokogiri
RUN cd /app
RUN apk add --update nodejs npm
RUN apk add --update tzdata
RUN apk add --update yarn
RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --without development test
RUN bundle install
RUN yarn install --check-files

COPY . /app
RUN RAILS_ENV=production FLUENT_D=false SECRET_KEY_BASE=`bin/rake secret` bundle exec rake assets:precompile

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
