##
# New Article Worker
#
class NewArticleWorker < Worker::Base
  recurrence { weekly .hour_of_day(6) }

  def perform

  end
end