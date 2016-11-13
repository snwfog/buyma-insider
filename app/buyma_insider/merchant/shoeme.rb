module Merchant
  module Shoeme
    def self.extended(merchant)
      merchant.indexer = ShoemeIndexer
      merchant.extend Parser
    end

    class ShoemeIndexer < Indexer
      def initialize(path, merchant)
        super("nav?initial_url=http://www.shoeme.ca/#{path}", merchant)
      end

      def compute_page
        raise 'Indexer#compute_page should have block' unless block_given?
        page_nodes = index_document.at_css(self.pager_css)
        first_node = page_nodes.at_css('ul li:first-child')
        last_node  = page_nodes.at_css('ul li:last-child')

        first_page = first_node.at_css('span.nxt-current').content.to_i
        /page-(?<last_page>[\d]{1,10})/ =~ last_node.at_css('a.nxt-pages-next')['href']
        (first_page..last_page.to_i).each { |i| yield "#{index_url}&page=#{i}" }
      end
    end

    module Parser
      def attrs_from_node(node)
        product_title_node = node.at_css('div.product-title')

        brand      = product_title_node.at_css('h5').content
        short_desc = product_title_node.at_css('h6').child.content.strip
        desc       = "#{brand} - #{short_desc}"

        encoded_link = product_title_node.at_css('a')['href']
        decoded_link = URI.decode(encoded_link)
        url_parts    = decoded_link.scan(URI.regexp).first.compact
        url_parts.shift
        link = "//#{url_parts.join}"

        {
          id:          "#{code}:#{Digest::MD5.hexdigest(desc)}",
          name:        desc,
          price:       node.at_css('div.product-price p.product-price').content[/[\d]{1,10}\.[\d]{2}/],
          description: desc,
          link:        link,
        }
      end
    end
  end
end