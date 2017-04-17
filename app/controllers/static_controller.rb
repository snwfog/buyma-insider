class StaticController < ApplicationController
  post '/login' do
    # TODO: Parameterize this
    redirect to('http://localhost:4200/', false)
  end
  
  get '/bootstrap' do
    @bootstrap ||= {
      server_version: BuymaInsider::VERSION
    }
    
    if user = current_user rescue nil
      @bootstrap['current_user'] = user.to_json
    end
    
    @bootstrap.to_json
  end
end