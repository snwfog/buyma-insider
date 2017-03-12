require_relative './setup'

# IMPT: Make sure do not use too much formatting, and try to keep
# on a single line as much as possible

r.table('crawl_histories').update(lambda { |history|
  { :traffic_size_kb => history['traffic_size'] / 1000 }
}).run(conn)

r.table('crawl_histories').replace(lambda { |history|
  history.without('traffic_size')
}).run(conn)
