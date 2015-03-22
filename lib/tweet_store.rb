class TweetStore
  class << self

    # Fetch tweets from the API and store them in the database.
    # Determine if a tweet already exists by looking it up from
    # its (API) ID.
    def fetch_and_store
      tweet_loader = Adaptive::TweetApi.new
      tweet_loader.load

      unless tweet_loader.has_error?
        tweets = []
        tweet_loader.messages.each do |message|
          tweet = Tweet.where(tweet_id: message['id']).first_or_initialize

          # Have we seen this tweet before?
          if tweet.persisted?
            tweet.update(viewed_count: tweet.viewed_count + 1)
          else
            tweet.update_from_json(message)
          end

          tweets << tweet
        end

        tweets
      else
        raise StandardError, tweet_loader.error_message
      end
    end

  end
end