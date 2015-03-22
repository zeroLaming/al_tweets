class Tweet < ActiveRecord::Base

  validates :tweet_id, presence: true, numericality: true
  validates :tweet_message, presence: true
  validates :tweet_sentiment, presence: true, numericality: { greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
  validates :tweet_followers, presence: true, numericality: true
  validates :tweet_user_handle, presence: true
  validates :tweet_updated_at, presence: true
  validates :tweet_created_at, presence: true

  scope :order_by_sentiment, -> {
    order('tweet_sentiment Desc')
  }

  def self.method_missing(method_sym, *args, &block)
    method = :"tweet_#{method_sym.to_s}"

    if self.respond_to?(method)
      self.send(method, *args)
    else
      super
    end
  end

end