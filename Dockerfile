FROM ruby:2.3.5

LABEL maintainer="wynn987@gmail.com"

# Instructions below modified from https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

# Set rails environment to test
ENV RAILS_ENV test
ENV SWAGGER_API_BASE_PATH qa-review-api.gds-gov.tech
ENV ADMIN_EMAIL guowen456@hotmail.com

# Install some required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  nodejs \
  libpq-dev \
  postgresql-client \
  clamav \
  clamav-daemon
  
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

# Run rails server on default port 3000
# CMD rails s