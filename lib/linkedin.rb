require 'oauth'
require 'nokogiri'
require 'crack'

require 'cgi'

module LinkedIn
  class LinkedInError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end

  class RateLimitExceeded < LinkedInError; end
  class Unauthorized      < LinkedInError; end
  class General           < LinkedInError; end

  class Unavailable    < StandardError; end
  class InformLinkedIn < StandardError; end
  class NotFound       < StandardError; end


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


require 'linked_in/base'

require 'linked_in/to_xml_helpers'
require 'linked_in/request_helpers'

require 'linked_in/api_standard_profile_request'
require 'linked_in/url_resource'
require 'linked_in/company'
require 'linked_in/country'
require 'linked_in/education'
require 'linked_in/error'
require 'linked_in/location'
require 'linked_in/position'
require 'linked_in/profile'
require 'linked_in/update'
require 'linked_in/network'
require 'linked_in/people'
require 'linked_in/connections'
require 'linked_in/client'
require 'linked_in/person'
require 'linked_in/recipient'
require 'linked_in/recipients'
require 'linked_in/message'
require 'linked_in/group'
require 'linked_in/birthdate'
require 'linked_in/recommendations'
require 'linked_in/current_share'
require 'linked_in/short_profile'