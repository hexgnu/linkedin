require 'oauth'

module LinkedIn

  class << self
    attr_accessor :token, :secret, :default_profile_fields

    # config/initializers/linkedin.rb (for instance)
    #
    # LinkedIn.configure do |config|
    #   config.token = 'consumer_token'
    #   config.secret = 'consumer_secret'
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

end


require 'linked_in/mash'
require 'linked_in/errors'
require 'linked_in/client'
