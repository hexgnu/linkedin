require 'linked_in/helpers/authorization'
require 'linked_in/connection'
require 'linked_in/request'

require 'linked_in/client/profile'

module LinkedIn
  class Client
    attr_reader :consumer_token, :consumer_secret, :consumer_options

    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, options={})
      @consumer_token   = ctoken
      @consumer_secret  = csecret
      @consumer_options = options
      options = LinkedIn.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include LinkedIn::Connection
    include LinkedIn::Request
    include Helpers::Authorization

    include LinkedIn::Client::Profile

  end

end
