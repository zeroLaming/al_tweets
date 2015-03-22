require "rails_helper"

RSpec.describe WelcomeController, type: :controller do

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    context "ordering" do
      before do
        @tweet_1 = new_tweet( sentiment: '0.1' )
        @tweet_2 = new_tweet( sentiment: '0.7' )
        @tweet_3 = new_tweet( sentiment: '-0.1' )
      end

      it "orders tweets by sentiment" do
        get :index
        expect(assigns(:tweets)).to eq([@tweet_2, @tweet_1, @tweet_3])
      end
    end
  end

  describe "GET #reload" do
    before do
      stub_request(:get, "adaptive-test-api.herokuapp.com/tweets.json").to_return(
        status: 200,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' },
        body: File.new(Rails.root.join('spec', 'responses', 'good_response.json'))
      )
    end

    it "responds successfully with an HTTP 200 status code" do
      get :reload, format: :js
      expect(response).to be_success
    end

    it "renders the reload js template" do
      get :reload, format: :js
      expect(response).to render_template("reload")
    end

    context "fetching tweets" do
      before do
        @tweet_1 = new_tweet
        @tweet_2 = second_tweet
      end

      it "assigns new tweets" do
        get :reload, format: :js
        expect(assigns(:tweets)).to eq([@tweet_1, @tweet_2])
      end
    end

    context "fetching new tweets with an error" do
      before do
        stub_request(:get, "adaptive-test-api.herokuapp.com/tweets.json").to_return(
          status: 500,
          headers: { 'Content-Type' => 'application/json; charset=utf-8' },
          body: File.new(Rails.root.join('spec', 'responses', 'error_response.json'))
        )
      end

      it "should set an error message" do
        get :reload, format: :js
        expect(assigns(:error_message)).to eq("I don't know what happened there")
      end

    end
  end

  private

  def new_tweet(attributes = {})
    tweet_attributes = {}.tap do |h|
      json_tweets.first.each do |k, v|
        h["tweet_#{k}"] = attributes[k.to_sym] || v
      end
    end
    Tweet.create!(tweet_attributes)
  end

  def second_tweet(attributes = {})
    tweet_attributes = {}.tap do |h|
      json_tweets.second.each do |k, v|
        h["tweet_#{k}"] = attributes[k.to_sym] || v
      end
    end
    Tweet.create!(tweet_attributes)
  end

  def json_tweets
    JSON.load(Rails.root.join('spec/responses/good_response.json'))
  end
end