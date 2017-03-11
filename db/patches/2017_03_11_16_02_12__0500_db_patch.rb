require_relative './setup'

r.table('crawl_sessions').get('42fvFAj4bL8L0i').do do |session|
  session.merge do
    r.table('crawl_histories')
             .filter(:crawl_session_id => session['id'])
             .pluck('finished_at')
             .max()
  end
end.run(conn)
