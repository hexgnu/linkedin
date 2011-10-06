require 'faraday_middleware'

module LinkedIn
  # @private
  module Connection
    private

    def connection
      options = {
        :proxy => proxy,
        :ssl => { :verify => false },
        :url => 'http://www.linkedin.com/',
      }

      connection = Faraday.new(options) do |builder|
          builder.use Faraday::Request::JSON
          builder.use Faraday::Request::UrlEncoded
          builder.use Faraday::Response::Mashify
          builder.use Faraday::Response::ParseJson
          builder.adapter(Faraday.default_adapter)
      end
    end
  end
end
