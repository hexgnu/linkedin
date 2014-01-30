require 'linked_in/version'

module LinkedIn
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {LinkedIn::API}
    VALID_OPTIONS_KEYS = [
      :adapter,
      :consumer_key,
      :consumer_secret,
      :default_profile_fields,
      :endpoint,
      :format,
      :gateway,
      :oauth_token,
      :oauth_token_secret,
      :proxy,
      :user_agent,
      :faraday_options].freeze

    # The adapter that will be used to connect if none is set
    DEFAULT_ADAPTER = :net_http

    # By default, don't set an application key
    DEFAULT_CONSUMER_KEY = nil

    # By default, don't set an application secret
    DEFAULT_CONSUMER_SECRET = nil

    # The endpoint that will be used to connect if none is set
    #
    DEFAULT_ENDPOINT = 'https://api.linkedin.com/v1'.freeze

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is preferred over XML because it is more concise and faster to parse.
    DEFAULT_FORMAT = :json

    # By default, don't set a user oauth token
    DEFAULT_OAUTH_TOKEN = nil

    # By default, don't set a user oauth secret
    DEFAULT_OAUTH_TOKEN_SECRET = nil

    # By default, don't set any profile fields
    DEFAULT_PROFILE_FIELDS = nil

    # By default, don't use a proxy server
    DEFAULT_PROXY = nil

    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "LinkedIn Ruby Gem #{LinkedIn::VERSION}".freeze

    DEFAULT_GATEWAY = nil

    DEFAULT_FARADAY_OPTIONS = {}.freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter                = DEFAULT_ADAPTER
      self.consumer_key           = DEFAULT_CONSUMER_KEY
      self.consumer_secret        = DEFAULT_CONSUMER_SECRET
      self.default_profile_fields = DEFAULT_PROFILE_FIELDS
      self.endpoint               = DEFAULT_ENDPOINT
      self.format                 = DEFAULT_FORMAT
      self.oauth_token            = DEFAULT_OAUTH_TOKEN
      self.oauth_token_secret     = DEFAULT_OAUTH_TOKEN_SECRET
      self.proxy                  = DEFAULT_PROXY
      self.user_agent             = DEFAULT_USER_AGENT
      self.gateway                = DEFAULT_GATEWAY
      self.faraday_options        = DEFAULT_FARADAY_OPTIONS
      self
    end
  end
end