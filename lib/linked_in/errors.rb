module LinkedIn
  module Errors
    class LinkedInError < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class UnauthorizedError      < LinkedInError; end
    class GeneralError           < LinkedInError; end
    class AccessDeniedError      < LinkedInError; end

    class UnavailableError       < StandardError; end
    class InformLinkedInError    < StandardError; end
    class NotFoundError          < StandardError; end
  end
end
