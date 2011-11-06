require 'oauth'

module LinkedIn

  class << self
    attr_accessor :token, :secret, :default_profile_fields

		# to see all debug information in log
    attr_accessor :debug
    def debug
    	@debug || false
    end
    
    # wether to use mock data instead of consuming real API requests
    attr_accessor :mocking
    def mocking
    	@mocking || false
    end
    
    # the mocker object to use to mock responses
    attr_accessor :mocker
    def mocker
    	@mocker || LinkedIn::Mocker.new
    end

    # config/initializers/linkedin.rb (for instance)
    #
    # LinkedIn.configure do |config|
    #   config.token = 'consumer_token'
    #   config.secret = 'consumer_secret'
    #   config.default_profile_fields = ['education', 'positions']
    #   config.debug = true
    #   config.mocking = true
    #   config.mocker = MyMocker.new	
    # end
    #
    # elsewhere
    #
    # client = LinkedIn::Client.new
    def configure
      yield self
      true
    end
  end

  autoload :Api,     "linked_in/api"
  autoload :Client,  "linked_in/client"
  autoload :Errors,  "linked_in/errors"
  autoload :Helpers, "linked_in/helpers"
  autoload :Mash,    "linked_in/mash"
  autoload :Mocker,  "linked_in/mocker"
  autoload :Search,  "linked_in/search"
  autoload :Version, "linked_in/version"
end
