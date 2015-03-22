require 'rails_helper'
require 'tweet/fetcher'

# Toggle to allow real connections
# WebMock.allow_net_connect!

describe Tweet::Fetcher do
  context "The API is up and running" do
    before do
      stub_request(:get, "adaptive-test-api.herokuapp.com/tweets.json").to_return(
        status: 200,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: File.new(Rails.root.join('spec', 'responses', 'good_response.json'))
      )
    end

    subject(:tweet_fetcher) {
      fetcher = Tweet::Fetcher.new
      fetcher.fetch
      fetcher
    }

    it "should not have any errors" do
      expect(tweet_fetcher.has_error?).to eq(false)
    end

    it "should return 2 tweets" do
      expect(tweet_fetcher.messages.size).to eq(2)
    end

    context "a valid message" do
      subject(:message) {
        tweet_fetcher.messages.first
      }

      it "should contain a numeric id" do
        expect(message['id']).to_not be_nil
      end

      it "should contain a message" do
        expect(message['message']).to_not be_nil
      end

      it "should contain a sentiment score from -1 to 1" do
        expect(message['sentiment']).to_not be_nil
        expect(message['sentiment']).to be_between(-1, 1).inclusive
      end

      it "should contain a user handle" do
        expect(message['user_handle']).to_not be_nil
      end

      it "should contain timestamps" do
        expect(message['updated_at']).to_not be_nil
        expect(message['created_at']).to_not be_nil
      end
    end
  end

  context "The API is having intermittent problems" do
    before do
      stub_request(:get, "adaptive-test-api.herokuapp.com/tweets.json").to_return(
        status: 500,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: File.new(Rails.root.join('spec', 'responses', 'error_response.json'))
      )
    end

    subject(:tweet_fetcher) {
      fetcher = Tweet::Fetcher.new
      fetcher.fetch
      fetcher
    }

    it "should have errors" do
      expect(tweet_fetcher.has_error?).to eq(true)
    end

    it "should have an error message" do
      expect(tweet_fetcher.error_message).to eq("I don't know what happened there")
    end

    it "should not have any tweets" do
      expect(tweet_fetcher.messages.size).to eq(0)
    end
  end

  context "The API is down" do
    before do
      stub_request(:get, "adaptive-test-api.herokuapp.com/tweets.json").to_timeout
    end

    subject(:tweet_fetcher) {
      fetcher = Tweet::Fetcher.new
      fetcher.fetch
      fetcher
    }

    it "should have errors" do
      expect(tweet_fetcher.has_error?).to eq(true)
    end

    it "should have an error message" do
      expect(tweet_fetcher.error_message).to eq("Oops - we couldn't complete that request!")
    end
  end
end