class UrlCache
  attr_accessor :cache
  delegate :<<, :add, :add?, :include?,
           to: :cache

  def initialize
    @cache ||= Set.new
  end
end
