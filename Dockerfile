FROM ruby:2.5.1
WORKDIR /usr/src/app

COPY . .
RUN bundle install