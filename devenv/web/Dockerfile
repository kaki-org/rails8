FROM circleci/ruby:2.7.2-node-browsers
RUN sudo apt-get update -qq && sudo apt-get install -y libvips-dev
RUN sudo mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN sudo bundle install --full-index
COPY . /app

ENV LANG C.UTF-8
