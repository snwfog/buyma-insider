app:     bundle exec unicorn -E $RACK_ENV -Iapp -c ./config/unicorn.rb
sidekiq: bundle exec sidekiq --environment $RACK_ENV \
                             --config ./config/sidekiq.yml \
                             --require ./config/application.rb

elasticsearch: /usr/local/bin/elasticsearch --daemon \
                                            --pid /usr/local/var/run/elasticsearch.pid

