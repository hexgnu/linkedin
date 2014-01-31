require 'cgi'
require 'faraday'
require 'faraday_middleware'

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
    private

    def authentication
      {
        :consumer_key => consumer_token,
        :consumer_secret => consumer_secret,
        :token => @auth_token,
        :token_secret => @auth_secret
      }
    end

    def authenticated?
      authentication.values.all?
    end

    def connection_options
      LinkedIn.faraday_options.merge({
        :headers => {
          'Accept' => "application/#{LinkedIn.format}",
          'User-Agent' => LinkedIn.user_agent,
          'x-li-format' => 'json'
        },
        :proxy => LinkedIn.proxy,
        :ssl => {:verify => false},
        :url => LinkedIn.endpoint
      })
    end

    def connection
      raise "Please authenticate first" unless authenticated?

      @connection ||= Faraday.new(connection_options) do |builder|
        builder.use Faraday::Request::OAuth, authentication
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::ParseJson
        builder.adapter(LinkedIn.adapter)
      end
    end

  end

end
