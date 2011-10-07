require 'faraday'
require 'faraday_middleware'
require 'faraday/oauth'

module LinkedIn
  # @private
  module Connection
    private

    def connection(options={})
      merged_options = faraday_options.merge({
        :headers => {
          'Accept' => "application/#{format}",
          'User-Agent' => user_agent,
          'x-li-format' => 'json'
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => options.fetch(:endpoint, api_endpoint)
      })

      Faraday.new(merged_options) do |builder|
        builder.use Faraday::Request::OAuth, authentication if authenticated?
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::Mashify
        builder.use Faraday::Response::ParseJson
        builder.adapter(adapter)
      end
    end
  end
end
