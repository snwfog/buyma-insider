require 'rethinkdb'

module Persistence
  class Conn
    include RethinkDB::Shortcuts

  end
end