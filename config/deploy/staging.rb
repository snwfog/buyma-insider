set :deploy_to, '/usr/local/var/www/buyma_insider'
server ENV['STAGING_SSH_SERVER'], user: ENV['STAGING_SSH_USER'], roles: :all

set :hostname, 'retina'
set :port_number, 8080
