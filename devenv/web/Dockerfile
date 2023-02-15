FROM ruby:3.2.1-slim-bullseye
RUN apt-get update -qq && apt-get install -y libvips-dev build-essential default-libmysqlclient-dev curl libssl-dev zlib1g-dev unzip
RUN curl -sS https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_16.x bullseye main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update -qq && apt-get install -y nodejs

WORKDIR /home/app
COPY Gemfile /home/app/Gemfile
COPY Gemfile.lock /home/app/Gemfile.lock
ARG BUNDLER_VERSION
RUN gem update --system &&\
    gem install bundler:$BUNDLER_VERSION &&\
    bundle config set force_ruby_platform true && \
    bundle install --full-index -j4 --retry 6 --no-cache
COPY . /home/app

ENV LANG C.UTF-8
