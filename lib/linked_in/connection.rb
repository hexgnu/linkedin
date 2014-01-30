require 'faraday'
require 'faraday_middleware'

module LinkedIn
  module Connection
    private
    def connection_options
      {
        :headers => {
          'Accept' => "application/#{format}",
          'User-Agent' => user_agent,
          'x-li-format' => 'json'
        },
        :proxy => proxy,
        :ssl => {:verity => false},
        :url => api_endpoint
      }
    end

    def connection
      Faraday.new(connection_options) do |builder|
        builder.use Faraday::Request::OAuth, authentication
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::ParseJson
        builder.adapter(adapter)
      end
    end
  end
end
