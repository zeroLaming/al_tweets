class WelcomeController < ActionController::Base

  def index
    @tweets = Tweet.order_by_sentiment
  end

  def reload
    begin
      @tweets = TweetStore.fetch_and_store
    rescue StandardError => ex
      @error_message = ex.message
    end
  end

end