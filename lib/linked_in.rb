require 'oauth'
require 'linked_in/configuration'

module LinkedIn
  extend Configuration
  class << self
    attr_accessor :token, :secret, :default_profile_fields

    # config/initializers/linkedin.rb (for instance)
    #
    # ```ruby
    # LinkedIn.configure do |config|
    #   config.token = 'consumer_token'
    #   config.secret = 'consumer_secret'
    #   config.default_profile_fields = ['educations', 'positions']
    # end
    # ```
    # elsewhere
    #
    # ```ruby
    # client = LinkedIn::Client.new
    # ```
    def configure
      yield self
      true
    end
  end

  autoload :Api,     "linked_in/api"
  autoload :Client,  "linked_in/client"
  autoload :Mash,    "linked_in/mash"
  autoload :Errors,  "linked_in/errors"
  autoload :Helpers, "linked_in/helpers"
  autoload :Search,  "linked_in/search"
  autoload :Version, "linked_in/version"
end
