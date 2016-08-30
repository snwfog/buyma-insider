ssh: ssh -NTL 8080:localhost:8080 -L 28015:localhost:28015 -L 6379:localhost:6379 snw@mini.local

sidekiq: bundle exec sidekiq -r ./workers/buyma_insider_worker.rb
sidekiq_web: rackup --quiet
