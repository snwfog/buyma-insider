require_relative './setup'

meta_db_patch_table = 'meta_db_patches'
unless r.table_list().run.include?(meta_db_patch_table)
  begin
    r.table_create(meta_db_patch_table, primary_key: :name).run
  rescue
    puts $!
    exit
  end
end

# Grab all 2016 patches
applied_patches = r.table(meta_db_patch_table)
                    .order_by('run_at')
                    .run
                    .collect { |p| p['name'] }

patches = Rake::FileList['./db/patches/2016_*.rb'].pathmap('%n').map do |patch|
  unless applied_patches.include? patch
    Hash[:run_at, Time.now.iso8601, :name, patch]
  end
end.compact

if patches.empty?
  puts 'No patches applied...'
else
  puts 'Applying these patches...'
  puts patches.map { |p| p[:name] }
  r.table(meta_db_patch_table).insert(Array(patches)).run
end

