# $LOAD_PATH.unshift(File.expand_path('lib'), File.dirname(__FILE__))

require 'sidekiq/web'
require 'sidetiq/web'
# require 'require_all'
# require_all 'buyma_insider/workers'

Sidekiq::Web.run!
