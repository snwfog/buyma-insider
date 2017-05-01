class UserChannel
  MessageBus.subscribe('/users') do |message|
    puts message
  end
end