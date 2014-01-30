require 'faraday'
require 'faraday_middleware'

module LinkedIn
  module Connection
    private
    def connection_options
      faraday_options.merge({
        :headers => {
          'Accept' => "application/#{format}",
          'User-Agent' => user_agent,
          'x-li-format' => 'json'
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => api_endpoint
      })
    end

    def connection
      @connection ||= Faraday.new(connection_options) do |builder|
        builder.use Faraday::Request::OAuth, authentication
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::ParseJson
        builder.adapter(adapter)
      end
    end
  end
end
