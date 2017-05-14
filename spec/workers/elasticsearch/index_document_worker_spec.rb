require_relative '../../setup'

describe Elasticsearch::IndexDocumentWorker do
  let(:article) { get_article.tap(&:save) }
  it 'should sync to elasticsearch' do
    Elasticsearch::IndexDocumentWorker.new.perform(article.merchant.id,
                                                   :article,
                                                   article.to_h.to_hash)
  end
end