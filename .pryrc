require 'buyma_insider'

# activerecord
ActiveRecord::Base.establish_connection(BuymaInsider.configuration.postgres)

# rethinkdb
include RethinkDB::Shortcuts
URI.parse(BuymaInsider.configuration.database.uri).tap do |uri|
  r.connect({ user:     uri.user && URI.decode(uri.user),
              password: uri.password && URI.decode(uri.password),
              host:     uri.host,
              port:     uri.port,
              db:       uri.path[1, -1] }).repl
end

slack_notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
elastic_client = Elasticsearch::Client.new(BuymaInsider.configuration.elasticsearch)

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
  merchant = Merchant.find_by_code(:zar)
  sku      = Faker::Code.ean
  Article.new(merchant:    merchant,
              sku:         sku,
              name:        Faker::Commerce.product_name,
              price:       Faker::Commerce.price,
              description: Faker::Commerce.product_name,
              link:        '//test1.com')
end

def get_user
  User.new(username:      Faker::Internet.user_name,
           email_address: Faker::Internet.email,
           password:      123)
end

def json_serialize(object)
  ActiveModelSerializers::SerializableResource.new(object, include: '**')
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
