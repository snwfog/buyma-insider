module ElasticsearchHelper
  def elasticsearch_query(options = {})
    options[:index] ||= :shakura
    options[:type]  ||= :article
    
    elastic_query_results = $elasticsearch.with do |conn|
      conn.search(options)
    end
    
    # TODO: Hashie is slow
    Hashie::Mash.new(elastic_query_results)
  end
end