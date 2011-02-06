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

end