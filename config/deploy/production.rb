set :deploy_to, '/usr/local/var/www/buyma_insider'
server ENV['PRODUCTION_SSH_SERVER'], user: ENV['PRODUCTION_SSH_USER'], roles: :all

set :hostname, 'mini'
set :port_number, 8080

set :default_env, { PATH: '/usr/local/bin:$PATH' }

after 'deploy:updated', 'db_migrate'
after 'deploy:published', 'flush_redis'
after 'deploy:published', 'setup_env'
after 'deploy:published', 'reload_monit'
after 'deploy:published', 'restart_services'

desc 'Db migrate'
task :db_migrate do
  on roles(:all) do |host|
    within release_path do
      execute(:bundle, :exec, :rake, 'db:migrate')
    end
  end
end

desc 'Flush redis cache'
task :flush_redis do
  on roles(:all) do |host|
    # capture(execute(:env))
    # capture(execute(:bundle, :env))
    execute :'redis-cli', '-n 1', 'flushdb'
    execute :'redis-cli', '-n 0', 'del static:bootstrap'
  end
end

desc 'Copy production dotenv to app path'
task :setup_env do
  on roles(:all) do
    within shared_path do
      execute :cp, 'dotenv', "#{current_path}/.env"
    end
  end
end

desc 'Copy monitrc to home dir and reload'
task :reload_monit do
  on roles(:all) do
    within current_path do
      execute :cp, '.monitrc', '~/.monitrc'
      execute :monit, :reload
    end
  end
end

desc 'Restart services'
task :restart_services do
  on roles(:all) do
    execute :monit, :restart, :unicorn_master
    execute :monit, :restart, :sidekiq_1
  end
end
