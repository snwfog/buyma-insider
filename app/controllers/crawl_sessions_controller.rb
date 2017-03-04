require_relative './application'

class CrawlSessionsController < ApplicationController
  get '/' do
    sessions = if params.key? 'merchant'
                 CrawlSession.where(merchant_id: params[:merchant])
               else
                 CrawlSession
               end
    render_json sessions.all
  end
end