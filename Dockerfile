# Sidekiq for windows
# All list of docker ruby image maintained: https://github.com/docker-library/official-images/blob/master/library/ruby
# Dockerfile: https://github.com/docker-library/ruby/blob/master/2.3/alpine/Dockerfile
FROM ruby:2.3-slim

# Maybe .dockerignore is useless if we pulling from git
# Upd: Actually the docker image we build from will COPY . /usr/src/app,
#      so this might not actually be used
# Upd 2: I don't see the COPY command
# URL https://github.com/snwfog/buyma_insider.git

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN apt-get update
RUN apt-get -y install git vim iptables
RUN apt-get -y install build-essential

RUN bundle config github.https true
RUN bundle install
CMD /bin/bash
# CMD bundle exec sidekiq --environment development \
#                         --require ./config/application.rb \
#                         --pidfile ./tmp/pids/sidekiq_1.pid \
#                         --logfile ./log/sidekiq_1.log \
#                         --concurrency 1

# bundle exec sidekiq -e development -r ./config/application.rb -P ./tmp/pids/sidekiq_1.pid -L ./log/sidekiq_1.log -C 1


