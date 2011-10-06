require 'linked_in/helpers/authorization'
require 'linked_in/connection'
require 'linked_in/request'

module LinkedIn
  class Client
    attr_reader :consumer_token, :consumer_secret, :consumer_options

    def initialize(ctoken=LinkedIn.token, csecret=LinkedIn.secret, options={})
      @consumer_token   = ctoken
      @consumer_secret  = csecret
      @consumer_options = options
    end

    include LinkedIn::Connection
    include LinkedIn::Request
    include Helpers::Authorization

  end

end
