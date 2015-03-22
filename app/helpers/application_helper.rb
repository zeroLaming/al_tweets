module ApplicationHelper

  def image_for_sentiment(sentiment)
    image = case sentiment.to_f
      when -1..-0.1 then 'negative'
      when -0..0.5 then 'neutral'
      when 0.6..1 then 'positive'
      else
        nil
      end

    image_tag "#{image}.png" if image
  end

end