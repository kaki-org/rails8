FROM cimg/ruby:3.1.0-browsers
RUN sudo apt-get update -qq && sudo apt-get install -y libvips-dev
#RUN sudo mkdir -p /home/circleci
WORKDIR /home/circleci
COPY Gemfile /home/circleci/Gemfile
COPY Gemfile.lock /home/circleci/Gemfile.lock
RUN sudo bundle install --full-index
COPY . /home/circleci

ENV LANG C.UTF-8
