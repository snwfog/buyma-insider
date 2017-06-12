#
class IndexPagesController < ApplicationController
  options '/**' do; end

  before '/:id(/**)?' do
    param :id, String, required: true

    @index_page = IndexPage.find(params[:id])
  end

  post '/:id/_refresh' do
    if IndexPageCrawlWorker.perform_async(index_page_id:   @index_page.id,
                                          no_cache:        true,
                                          schedule_parser: true)
      status :created
      json @index_page.reload
    else
      status :conflict and halt
    end
  end
  
  get '/:id' do
    json @index_page
  end
end
