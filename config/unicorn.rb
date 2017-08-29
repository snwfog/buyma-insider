# set path for bundler
# ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
# require 'bundler/setup'

app_dir = File.expand_path('../..', __FILE__)
working_directory app_dir
worker_processes  2

# set master PID location
pid               "#{app_dir}/tmp/pids/unicorn.pid"
preload_app       true
timeout           30

# set up socket location
listen            "#{app_dir}/tmp/sockets/unicorn.sock", backlog: 64

# logging
stderr_path       "#{app_dir}/log/unicorn-stderr.log"
stdout_path       "#{app_dir}/log/unicorn-stdout.log"

before_fork do |server, worker|
  # get rid of rubbish
  GC.start
end

after_fork do |server, worker|
  # establish db connection
  ActiveRecord::Base.establish_connection(BuymaInsider.configuration.postgres)
end
