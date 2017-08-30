# Load .env
require 'dotenv/load'
# Load DSL and set up stages
require 'capistrano/setup'
# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/scm/git'
require 'capistrano/capistrano_plugin_template'

install_plugin Capistrano::SCM::Git

# Ensure rbenv specified ruby is used
require 'capistrano/rbenv'

# Ensure that we can install bundled gems
require 'capistrano/bundler'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
