class SayHiWorker
  include Sidekiq::Worker

  def perform
    puts 'Doing stuff'.blue
  end
end

SayHiWorker.perform_async
