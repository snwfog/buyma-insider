module Merchants
  module YvesSaintLaurentBeautyCanada
    def query_strings
      { format: :ajax,
        sz:     120 } # page size, looks like it works with large number
    end

    def extract_index_pages!(root_index_page)
      pager_node = super
      if pager_node.nil?
        []
      else
        # grab largest pages and split
        href                = pager_node.css('ul li.pagination_list_item a.pagination_list_link').last['href']
        uri                 = URI(href)
        query_strings       = Rack::Utils.parse_nested_query(uri.query)
        articles_per_page   = query_strings['sz'].to_i
        last_page_starts_at = query_strings['start'].to_i
        max_articles        = articles_per_page + last_page_starts_at - 1

        (0..max_articles).step(120) do |page_starts_at|
          relative_path = root_index_page.relative_path + "?start=#{page_starts_at}"
          root_index_page.index_pages.build(relative_path: relative_path, merchant: self)
        end
      end
    end

    def extract_attrs!(node)
      article_node        = node.at_css('div.action_product_block') # more specific article div block
      product_sku         = node['data-itemid']
      product_name        = article_node.at_css('a.product_name')['title'].squish.downcase
      product_link        = URI(article_node.at_css('a.product_name')['href'])
      product_description = article_node.at_css('div.description').content.squish
      product_price       = article_node.at_css('p.product_price')['data-pricevalue']

      { sku:         product_sku,
        name:        product_name,
        description: product_description.blank? ? product_name.capitalize : product_description,
        link:        "//#{product_link.host}#{product_link.path}",
        price:       product_price }
    end
  end
end