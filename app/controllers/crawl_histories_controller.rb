require_relative './application'

class CrawlHistoriesController < ApplicationController
  get '/crawl_histories' do
    render_json CrawlHistory.all
  end
  
  get '/crawl_histories/:merchant_id' do
    render_json CrawlSession
                  .where(merchant_id: params[:merchant_id])
                  .order_by(created_at: :desc)
                  .limit(10)
                  .all
  end
end