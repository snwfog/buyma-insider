require 'buyma_insider'

include RethinkDB::Shortcuts

client = Elasticsearch::Client.new
conn   = r.connect(db: :"buyma_insider_#{BuymaInsider.environment}")
conn.repl

$es = $elasticsearch
# def search_with_template(body)
#   $elasticsearch.search_template(index: :_all, type: :article, body: body)
# end
#
# def get_search_template_tester
#   search_template_tester = Tempfile.create(['search_template_tester', '.yml'], './tmp')
#   puts search_template_tester.path
#   search_q = -> () { YAML::load_file(search_template_tester_path) }
# end

def get_article
  Article.new({ id:          "abc:#{Faker::Code.ean}",
                merchant_id: 'zar',
                sku:         Faker::Code.ean,
                name:        Faker::Commerce.product_name,
                price:       Faker::Commerce.price,
                description: Faker::Commerce.product_name,
                link:        '//test1.com', })
end

def get_user
  User.new({ username: Faker::Internet.user_name,
             email:    Faker::Internet.email,
             password: 123 })
end

require 'net/http'
OracleProxyHttp = Net::HTTP::Proxy('adc-proxy.oracle.com', 80)

def proxy_fetch(uri, **opts)
  opts[:use_ssl] = true
  OracleProxyHttp.start(uri.hostname, uri.port, opts) do |http|
    http.request(Net::HTTP::Get.new(uri))
  end
end

def fetch(uri, **opts)
  opts[:use_ssl] = true
  Net::HTTP::start(uri.hostname, uri.port, opts) do |http|
    http.request(Net::HTTP::Get.new(uri))
  end
end

