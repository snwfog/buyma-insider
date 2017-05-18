# set path to application
app_dir = File.expand_path('../..', __FILE__)
working_directory app_dir

# Set master PID location
pid "#{app_dir}/tmp/pids/unicorn.pid"

# Set unicorn options
worker_processes 2
preload_app false
timeout 30

# Set up socket location
listen "#{app_dir}/tmp/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{app_dir}/log/unicorn-stderr-#{ENV['RACK_ENV']}.log"
stdout_path "#{app_dir}/log/unicorn-stdout-#{ENV['RACK_ENV']}.log"

