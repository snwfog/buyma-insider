desc 'Report uptimes'
task :uptime do
  on roles(:all) do |host|
    # execute :uptime
    info "Host #{host} (#{host.roles.to_a.join(', ')}:\t#{capture(:uptime)}"
  end
end
