require 'rake'
require 'any_bar'

desc 'Start sidekiq'
task :sidekiq do
  sh 'bundle execute sidekiq -r ./workers/buyma_insider_worker.rb'
end

desc 'Run test'
task :test do
  sh 'bundle execute pry -Iworkers:lib:spec ./spec/ssense_spec.rb'
end

desc 'Setup ssh'
task :ssh do
  # sh 'ANYBAR_PORT=1735 open -na AnyBar'
  # sh 'ANYBAR_PORT=1736 open -na AnyBar'
  # sh 'ANYBAR_PORT=1737 open -na AnyBar'
  #
  # AnyBar::Client.new(1735).color = 'green'
  # AnyBar::Client.new(1736).color = 'green'
  # AnyBar::Client.new(1737).color = 'green'

  sh 'ssh -NTL 8080:localhost:8080 -L 28015:localhost:28015 -L 6379:localhost:6379 snw@mini.local'
end