module Concerns
  ##
  # Expect on @items and process them into models
  module Processor
    def process(*args, &block)
      @items.each do |html_node|
        # Build skeleton article
        article    = article_model.from_node(html_node)
        db_article = article_model.find?(article.id)

        # Set new price
        if db_article
          db_article.price = article.price
          article          = db_article
        end

        # Preprocessing before saving
        yield article if block_given?
        article.save
      end
    end
  end
end
