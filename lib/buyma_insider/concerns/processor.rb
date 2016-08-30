module Concerns
  ##
  # Expect on @items and process them into models
  module Processor
    def process(*args, &block)
      @items.each do |html_node|
        # Build skeleton article
        attrs   = merchant.article_model.attrs_from_node(html_node)
        article = Article.upsert(attrs)
        # Preprocessing before saving
        yield article if block_given?
      end
    end
  end
end
