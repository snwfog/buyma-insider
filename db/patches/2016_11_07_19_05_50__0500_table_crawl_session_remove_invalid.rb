require 'rethinkdb'
require 'patches/setup'

# Delete all crawl session that do not have valid histories
CrawlSession.all.each do |crawl_session|
  unless crawl_session.valid?
    puts 'Deleting [CrawlSession]'
    puts crawl_session
    puts crawl_session.errors.full_messages
    crawl_session.delete
    puts "=================================\n"
  end
end

