set :deploy_to, '/usr/local/var/www/buyma_insider'
server ENV['PRODUCTION_SSH_SERVE'], user:  ENV['PRODUCTION_SSH_USER'],
                                    roles: :all

# Elasticsearch path, where to copy scripts and settings
set :elasticsearch_path, '/usr/local/etc/'
