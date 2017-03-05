app: bundle exec unicorn -c ./config/unicorn.rb -E $RACK_ENV
sidekiq: bundle exec sidekiq --environment $RACK_ENV --config ./config/sidekiq.yml --require ./sidekiq.rb
sidekiq_web: rackup --quiet --port 5200 -E $RACK_ENV config.sidekiq.ru
