require 'linked_in/authentication'
require 'linked_in/configuration'
require 'linked_in/connection'
require 'linked_in/request'

module LinkedIn
  # @private
  class API
    include Connection
    include Request
    include Authentication

    # @private
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    # Creates a new API
    def initialize(options={})
      options = LinkedIn.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end
