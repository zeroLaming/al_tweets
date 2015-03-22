require 'rails_helper'

describe Tweet, type: :model do

  context "a valid tweet" do
    subject(:tweet) {
      new_tweet
    }

    it "should be valid" do
      expect(tweet).to be_valid
    end

    it "should have a message present" do
      expect(new_tweet({ message: '' })).to have_exactly(1).errors_on(:tweet_message)
    end

    it "should have an ID present" do
      expect(new_tweet({ id: '' })).to have_exactly(2).errors_on(:tweet_id)
    end

    it "should have followers present" do
      expect(new_tweet({ followers: '' })).to have_exactly(2).errors_on(:tweet_followers)
    end

    it "should have sentiment set correctly" do
      expect(new_tweet({ sentiment: '5' })).to have_exactly(1).errors_on(:tweet_sentiment)
    end

    it "should have timestamps" do
      expect(new_tweet({ updated_at: '' })).to have_exactly(1).errors_on(:tweet_updated_at)
      expect(new_tweet({ created_at: '' })).to have_exactly(1).errors_on(:tweet_created_at)
    end
  end

  private

  def new_tweet(attributes = {})
    json = JSON.load(Rails.root.join('spec/responses/good_response.json'))
    tweet_attributes = {}.tap do |h|
      json.first.each do |k, v|
        h["tweet_#{k}"] = attributes[k.to_sym] || v
      end
    end
    Tweet.new(tweet_attributes)
  end

end