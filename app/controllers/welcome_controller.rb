class WelcomeController < ApplicationController

  def index
    @highlight = %w( coke coca-cola diet cola )
    set_tweets
  end

  def reload
    begin
      TweetStore.fetch_and_store
      set_tweets
    rescue StandardError => ex
      @error_message = ex.message
    end
  end

  def clear
    Tweet.delete_all
  end

  private

  def set_tweets
    @tweets = Tweet.order_by_sentiment
  end

end