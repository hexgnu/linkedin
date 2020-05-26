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
  end
end
