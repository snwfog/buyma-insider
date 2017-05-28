nginx:         /usr/local/bin/nginx
www:           bundle exec unicorn -E $RACK_ENV -Iapp -c ./config/unicorn.rb
redis:         /usr/local/bin/redis
sidekiq:       bundle exec sidekiq --environment $RACK_ENV --config ./config/sidekiq.yml --require ./config/application.rb
rethinkdb:     /usr/local/bin/rethinkdb
elasticsearch: /usr/local/bin/elasticsearch --daemon --pid /usr/local/var/run/elasticsearch.pid

