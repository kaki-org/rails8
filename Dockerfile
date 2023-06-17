FROM ruby:3.2.2 AS nodejs

WORKDIR /tmp

RUN curl -LO https://nodejs.org/dist/v16.14.0/node-v16.14.0-linux-x64.tar.xz
RUN tar xvf node-v16.14.0-linux-x64.tar.xz
RUN mv node-v16.14.0-linux-x64 node

FROM ruby:3.2.2

COPY --from=nodejs /tmp/node /opt/node
ENV PATH /opt/node/bin:$PATH

RUN useradd -m -u 1000 rails
RUN mkdir /app && chown rails /app
USER rails

RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH /home/rails/.yarn/bin:/home/rails/.config/yarn/global/node_modules/.bin:$PATH

RUN gem install bundler

WORKDIR /app

COPY --chown=rails Gemfile Gemfile.lock package.json yarn.lock /app/

RUN bundle install
RUN yarn install

COPY --chown=rails . /app

RUN bin/rails assets:precompile

VOLUME /app/public

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
