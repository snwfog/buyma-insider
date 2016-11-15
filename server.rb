require "socket"

# Create the socket and "save it" to the file system
puts Dir.pwd
server = UNIXServer.new('./shared/sockets/unicorn.sock')

# Wait until for a connection (by nginx)
socket = server.accept

# Read everything from the socket
while line = socket.readline
  puts line.inspect
end

socket.close
