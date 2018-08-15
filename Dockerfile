FROM ruby:2.3.7-slim-jessie

LABEL maintainer="wynn"

# Instructions below modified from https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

# Install some required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  imagemagick \
  build-essential \
  nodejs \
  libpq-dev \
  postgresql-client \
  clamdscan

RUN apt-get update && apt-get -y install --only-upgrade \
    openssl 

RUN apt-get clean

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

# Copy Gemfile and Gemfile.lock to container to install gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

# Copy in rest of app
COPY . .
RUN ["chmod", "+x", "docker/docker-entrypoint-test.sh"]
# Run rails server on default port 3000
# CMD rails s