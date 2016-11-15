web: bundle exec unicorn -c ./config/unicorn.rb -E $ENVIRONMENT
sidekiq: bundle exec sidekiq --environment $ENVIRONMENT --config ./config/sidekiq.yml --require ./sidekiq.rb
sidekiq_web: rackup --quiet --port 5200 --env $ENVIRONMENT
