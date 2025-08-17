# ビルド用コンテナ
ARG IMAGE_FILE
FROM $IMAGE_FILE:3.4.5-alpine3.22 AS builder
RUN apk --update --no-cache add --virtual build-dependencies \
    build-base \
    g++ \
    gcc \
    gcompat \
    git \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    make \
    readline-dev \
    yaml-dev \
    zlib-dev
RUN apk --update --no-cache add \
    bash \
    imagemagick \
    mariadb-client \
    mariadb-dev \
    tzdata \
    yarn
ENV APP_PATH /work/app
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH
COPY Gemfile.lock $APP_PATH
RUN gem update bundler \
    && bundle config set force_ruby_platform true \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    && apk del build-dependencies # --virtual でグルーピングしたpackageを削除
RUN rm -rf /usr/local/bundle/cache/*

FROM ${IMAGE_FILE}:3.4.5-alpine3.22
RUN apk --no-cache add \
    build-base \
    bash \
    file \
    make \
    curl \
    gcompat \
    gcc \
    libffi-dev \
    yarn \
    readline-dev \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    mariadb-client \
    mariadb-dev \
    nodejs \
    npm \
    imagemagick  \
    tzdata
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV APP_PATH /work/app
WORKDIR $APP_PATH
COPY . $APP_PATH
COPY --from=builder /usr/local/bundle /usr/local/bundle

CMD ["bin/rails", "s"]
