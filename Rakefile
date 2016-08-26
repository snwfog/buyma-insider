require 'rake'

desc 'Start sidekiq'
task :sidekiq do
  sh 'bundle execute sidekiq -r ./workers/buyma_insider_worker.rb'
end

desc 'Run test'
task :test do
  sh 'bundle execute pry -Iworkers:lib:spec ./spec/ssense_spec.rb'
end