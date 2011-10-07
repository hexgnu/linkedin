require 'oauth'
require 'linked_in/configuration'
require 'linked_in/client'
require 'linked_in/errors'

module LinkedIn
  extend Configuration
  class << self
    attr_accessor :token, :secret, :default_profile_fields

    # config/initializers/linkedin.rb (for instance)
    #
    # LinkedIn.configure do |config|
    #   config.token = 'consumer_token'
    #   config.secret = 'consumer_secret'
    #   config.default_profile_fields = ['education', 'positions']
    # end
    #
    # elsewhere
    #
    # client = LinkedIn::Client.new
    def new(token, secret, options={})
      LinkedIn::Client.new(options)
    end
  end

end
