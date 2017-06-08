namespace :linux do
  desc 'Provision linux remote server'
  task provision: [:distro_upgrade, :setup_rbenv, :setup_ruby_build]
  
  desc 'Verify os'
  task :verify_os do
    on roles(:all) do |host|
      info 'Checking for OS restriction...'
      unless capture('uname', '-a') =~ /Linux/
        fail 'Only support linux'
      end
    end
  end
  
  desc 'Distro upgrade'
  task distro_upgrade: [:verify_os] do
    on roles(:all) do
      execute 'apt-get', '-y', 'dist-upgrade'
      execute 'apt-get', '-y', 'upgrade'
      execute 'apt-get', '-y', 'update'
      execute 'apt-get', '-y', 'install', 'build-essential'
      execute 'apt-get', '-y', 'install', 'git-core'
    end
  end
  
  desc 'Setup rbenv'
  task setup_rbenv: [:verify_os] do
    on roles(:all) do
      within('~') do
        execute %Q(git clone https://github.com/rbenv/rbenv.git ~/.rbenv)
      end
    end
  end
  
  desc 'Setup ruby-build'
  task setup_ruby_build: [:verify_os] do
    on roles(:all) do
      within('~') do
        set :ruby_version, ask('Ruby version', '2.3.1')
        unless test('[ -d "$HOME/.rbenv/plugins/ruby-build" ]')
          execute %Q(git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build)
        end
        execute %Q($HOME/.rbenv/bin/rbenv install #{fetch(:ruby_version)})
      end
    end
  end
end
