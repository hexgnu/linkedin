require 'cgi'

module LinkedIn

  class Client
    include Helpers::Request
    include Helpers::Authorization
    include Api::QueryHelpers
    include Api::People
    include Api::Groups
    include Api::Companies
    include Api::Jobs
    include Api::ShareAndSocialStream
    include Api::Communications
    include Search

    attr_reader :consumer_token, :consumer_secret, :consumer_options

    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, options={})
      @consumer_token   = ctoken
      @consumer_secret  = csecret
      @consumer_options = options
    end

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
