class WelcomeController < ApplicationController

  def index
    @highlight = %w( coke coca-cola diet cola )
    @tweets = Tweet.order_by_sentiment
  end

  def reload
    begin
      @new_tweets = TweetStore.fetch_and_store
      @tweets = Tweet.order_by_sentiment
    rescue StandardError => ex
      @error_message = ex.message
    end
  end

  def clear
    Tweet.delete_all
  end

end