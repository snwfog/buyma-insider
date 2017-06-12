set :deploy_to, '/usr/local/var/www/buyma_insider'
server ENV['STAGING_SSH_SERVER'], user:  ENV['STAGING_SSH_USER'],
                                  roles: :all

# Elasticsearch path, where to copy scripts and settings
set :elasticsearch_path, '/usr/local/etc/'
