# require 'forwardable'
# require 'rubygems'
#
gem 'oauth', '~> 0.4.0'
require 'oauth'

require 'nokogiri'

gem 'crack', '~> 0.1.4'
require 'crack'

require 'cgi'

# class Nokogiri::XML::Element
#   def has_key?(key)
#     self.keys.include?(key)
#   end
# end

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

  class Unavailable   < StandardError; end
  class InformLinkedIn < StandardError; end
  class NotFound      < StandardError; end

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
  def self.configure
    yield self

    LinkedIn.token = token
    LinkedIn.secret = secret
    true
  end

  def self.token
    @token
  end

  def self.token=(token)
    @token = token
  end

  def self.secret
    @secret
  end

  def self.secret=(secret)
    @secret = secret
  end
end

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'linked_in', 'base')

require File.join(directory, 'linked_in', 'api_standard_profile_request')
require File.join(directory, 'linked_in', 'url_resource')
require File.join(directory, 'linked_in', 'company')
require File.join(directory, 'linked_in', 'country')
require File.join(directory, 'linked_in', 'education')
require File.join(directory, 'linked_in', 'error')
require File.join(directory, 'linked_in', 'location')
require File.join(directory, 'linked_in', 'position')
require File.join(directory, 'linked_in', 'profile')
require File.join(directory, 'linked_in', 'update')
require File.join(directory, 'linked_in', 'network')
require File.join(directory, 'linked_in', 'people')
require File.join(directory, 'linked_in', 'connections')
require File.join(directory, 'linked_in', 'client')
require File.join(directory, 'linked_in', 'person')
require File.join(directory, 'linked_in', 'recipient')
require File.join(directory, 'linked_in', 'recipients')
require File.join(directory, 'linked_in', 'message')
require File.join(directory, 'linked_in', 'group')
require File.join(directory, 'linked_in', 'birthdate')

