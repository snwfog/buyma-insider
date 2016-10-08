$:.unshift(File.expand_path("lib"), File.dirname(__FILE__))

require 'sidekiq'
require 'logging'
require 'require_all'
require 'buyma_insider'

require_all './workers'

