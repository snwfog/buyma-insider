set :deploy_to, '/usr/local/var/www/buyma_insider'
server ENV['PRODUCTION_SSH_SERVER'], user: ENV['PRODUCTION_SSH_USER'], roles: :all

set :hostname, 'mini'
set :port_number, 8080
