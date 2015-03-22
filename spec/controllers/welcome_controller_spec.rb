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

  private

  def new_tweet(attributes = {})
    json = JSON.load(Rails.root.join('spec/responses/good_response.json'))
    tweet_attributes = {}.tap do |h|
      json.first.each do |k, v|
        h["tweet_#{k}"] = attributes[k.to_sym] || v
      end
    end
    Tweet.create!(tweet_attributes)
  end
end