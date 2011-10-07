require 'linked_in/api'
require 'linked_in/configuration'
require 'linked_in/client'
require 'linked_in/errors'

module LinkedIn
  extend Configuration
  class << self
    # Alias for LinkedIn::Client.new
    #
    # @return [LinkedIn::Client]
    def new(options={})
      LinkedIn::Client.new(options)
    end

    # Delegate to LinkedIn::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end

end
