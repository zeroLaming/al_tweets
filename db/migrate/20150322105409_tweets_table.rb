class TweetsTable < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :tweet_id
      t.text :tweet_message
      t.string :tweet_sentiment
      t.integer :tweet_followers
      t.string :tweet_user_handle
      t.datetime :tweet_updated_at
      t.datetime :tweet_created_at
      t.integer :viewed_count, default: 0
      t.timestamps
    end
  end
end
