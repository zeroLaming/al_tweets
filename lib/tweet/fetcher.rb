module Tweet
  class Fetcher
    API_URL = "http://adaptive-test-api.herokuapp.com/tweets.json"
    ERROR_MESSAGE = "Oops - we couldn't complete that request!"

    attr_reader :error_message, :messages

    def initialize
      @error_message = nil
      @messages = []
    end

    def fetch
      begin
        RestClient.get(API_URL) do |response, request, result, &block|
          case response.code
          when 200
            @messages = JSON.parse(response.body)
          when 500
            @error_message = JSON.parse(response.body)['error']['message']
          else
            response.return!(request, result, &block)
          end
        end
      rescue Exception => ex
        @error_message = ERROR_MESSAGE
      end
    end

    def has_error?
      @error_message.present?
    end
  end
end