# Not used for now
class IndexPageArticle
  include NoBrainer::Document
  
  belongs_to :index_page, index:    true,
                          required: true
  
  belongs_to :article,    index:    true,
                          required: true
end