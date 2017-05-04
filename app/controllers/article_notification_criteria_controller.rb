class ArticleNotificationCriteriaController < ApplicationController
  get '/' do
    json ArticleNotificationCriterium.all
  end
end