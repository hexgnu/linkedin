# require 'forwardable'
require 'rubygems'

gem 'oauth', '~> 0.3.5'
require 'oauth'

gem 'roxml', '~> 3.1.3'
require 'roxml'

gem 'crack', '~> 0.1.4'
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

  class Unavailable   < StandardError; end
  class InformLinkedIn < StandardError; end
  class NotFound      < StandardError; end
end

directory = File.expand_path(File.dirname(__FILE__))

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