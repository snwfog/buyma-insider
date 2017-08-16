merchants_cfg = YAML.load_file(File.expand_path('config/merchant.yml'))

merchants_cfg.each do |_merchant_name, config|
  config.symbolize_keys!
  Merchant.seed do |m|
    m.code = config[:id]
    m.name = config[:name]
  end

  merchant = Merchant.find_by_code(config[:id])

  MerchantMetadatum.seed do |meta|
    meta.merchant_id = merchant.id
    meta.domain      = config[:domain]
    meta.pager_css   = config[:pager_css]
    meta.item_css    = config[:item_css]
    meta.ssl         = config[:ssl]
  end

  config[:index_pages].each do |relative_path|
    IndexPage.seed do |index_page|
      index_page.merchant_id   = merchant.id
      index_page.relative_path = relative_path
    end
  end
end