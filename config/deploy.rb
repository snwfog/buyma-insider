# config valid only for current version of Capistrano
lock '3.8.1'

set :application, 'buyma_insider'
set :repo_url, 'git@github.com:snwfog/buyma_insider.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
# set :deploy_to, '/usr/local/var/www/buyma_insider'

# rbenv
# set :rbenv_type, :user
# set :rbenv_custom_path, '/usr/local/Cellar/rbenv/1.1.1'
set :rbenv_ruby, '2.3.3'
# set :rbenv_ruby, File.read('.ruby-version').strip
# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# set :rbenv_map_bins, %w{rake gem bundle ruby}
# set :rbenv_roles, :all # default value

# bundler
# set :bundle_bins, fetch(:bundle_bins, []).push('my_new_binary')
# set :bundle_roles, :all                                         # this is default
# set :bundle_servers, -> { release_roles(fetch(:bundle_roles)) } # this is default
set :bundle_binstubs, -> { shared_path.join('bin') } # default: nil
# set :bundle_gemfile, -> { release_path.join('MyGemfile') }      # default: nil
# set :bundle_path, -> { shared_path.join('bundle') }             # this is default. set it to nil for skipping the --path flag.
# set :bundle_without, %w{development test}.join(' ')             # this is default
# set :bundle_flags, '--deployment --quiet'                       # this is default
set :bundle_flags, '--no-deployment --quiet' # this is default
# set :bundle_env_variables, {}                                   # this is default
# set :bundle_clean_options, ""                                   # this is default. Use "--dry-run" if you just want to know what gems would be deleted, without actually deleting them


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true
append :linked_dirs, *['log',
                       'tmp/configs',
                       'tmp/volumes',
                       'tmp/pids',
                       'tmp/cache',
                       'tmp/sockets']

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# Default value for keep_releases is 5
set :keep_releases, 3
set :ssh_options, { forward_agent: true,
                    auth_methods:  %w(publickey) }

# before 'deploy:check:linked_files', 'upload_linked_files'

# Configuration templates
append :templating_paths, 'config/deploy/templates'
after 'deploy:published', 'generate_config'

set :bin_dir, '/usr/local/bin'
set :unicorn_workers, 2
set :sidekiq_processes, 1

desc 'Generate and upload configuration files'
task :generate_config do
  on roles(:all) do
    FileList['redis.conf.erb',
             'rethinkdb.conf.erb',
             'default.nginx.erb',
             'elasticsearch.yml.erb',
             'sidekiq.yml.erb',
             '.monitrc.erb',
             '.env.erb'].each { |file| template file }
  end
end

# desc 'Setup linked files'
# task :upload_linked_files do
#   on roles(:all) do
#     FileList[*fetch(:app_linked_files)].each do |file|
#       upload!(file, "#{shared_path}/config")
#     end
#   end
# end

# @deprecated
# desc 'Download generated template to local for mirroring'
# task :download_erb_config do
#   on roles(:all) do
#     download! "#{current_path}/logging.yml", './logging.yml'
#   end
# end
