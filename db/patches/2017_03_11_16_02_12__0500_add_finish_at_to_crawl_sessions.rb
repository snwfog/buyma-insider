require_relative './setup'

# IMPT: Make sure do not use too much formatting, and try to keep
# on a single line as much as possible

r.table('crawl_sessions').update(lambda { |session|
  r.table('crawl_histories').filter(:crawl_session_id => session['id']).pluck('finished_at').max()
}, :non_atomic => true).run
