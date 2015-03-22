class WelcomeController < ActionController::Base

  def index
    @tweets = Tweet.order_by_sentiment
  end

  def reload

  end

end