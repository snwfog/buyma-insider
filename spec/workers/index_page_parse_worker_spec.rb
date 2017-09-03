require_relative '../setup'

describe IndexPageParseWorker do
  it 'should parse and create articles' do
    m          = Merchant.find_by_code!(:slf)
    index_page = m.index_pages.first
    IndexPageParseWorker.new.perform(index_page.id)
  end
end