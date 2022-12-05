FROM ruby:3.1.2-slim-bullseye
RUN apt-get update -qq && apt-get install -y libvips-dev build-essential default-libmysqlclient-dev curl libssl-dev zlib1g-dev unzip
WORKDIR /home/app
COPY Gemfile /home/app/Gemfile
COPY Gemfile.lock /home/app/Gemfile.lock
RUN bundle install --full-index
COPY . /home/app

ENV LANG C.UTF-8
