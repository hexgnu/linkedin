require 'hashie'
require 'multi_json'

module LinkedIn

  # The generalized pseudo-object that is returned for all query
  # requests.
  class Mash < ::Hashie::Mash

    # Convert a json string to a Mash
    #
    # @param [String] json_string
    # @return [LinkedIn::Mash]
    def self.from_json(json_string)
      result_hash = ::MultiJson.decode(json_string)
      new(result_hash)
    end

    # Returns a Date if we have year, month and day, and no conflicting key
    #
    # @return [Date]
    def to_date
      if !self.has_key?('to_date') && contains_date_fields?
        Date.civil(self.year, self.month, self.day)
      else
        super
      end
    end

    # Returns the id of the object from LinkedIn
    #
    # @return [String]
    def id
      if self['id']
        self['id']
      else
        self['_key']
      end
    end

    # Convert the 'timestamp' field from a string to a Time object
    #
    # @return [Time]
    def timestamp
      value = self['timestamp']
      if value.kind_of? Integer
        value = value / 1000 if value > 9999999999
        Time.at(value)
      else
        value
      end
    end

    # Return the results array from the query
    #
    # @return [Array]
    def all
      super || []
    end

    protected

      def contains_date_fields?
        self.year? && self.month? && self.day?
      end

      # overload the convert_key mash method so that the LinkedIn
      # keys are made a little more ruby-ish
      def convert_key(key)
        case key.to_s
        when '_total'
          'total'
        when 'values'
          'all'
        when 'numResults'
          'total_results'
        else
          underscore(key)
        end
      end

      # borrowed from ActiveSupport
      # no need require an entire lib when we only need one method
      def underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, '/')
        word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

  end
end
