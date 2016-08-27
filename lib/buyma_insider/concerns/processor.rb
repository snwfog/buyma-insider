module Concerns
  ##
  # Expect on @items and process them into models
  module Processor
    def process(*args, &block)
      @items.each do |html_node|
        # Build skeleton article
        article          = article_model.from_node(html_node)
        existing_article = article_model.find?(article.id)

        # Preprocessing before saving
        yield article if block_given?
        article.save if existing_article.nil?
      end
    end
  end
end