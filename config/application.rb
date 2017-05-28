$LOAD_PATH.unshift(File.expand_path('../../app', __FILE__))
# puts __FILE__
# puts File.expand_path(__FILE__)
# puts File.expand_path('../../app', __FILE__)
# puts $LOAD_PATH
# Sidekiq will use this to boot process
# e.g. File.exist? './config/application.rb'
require 'buyma_insider'