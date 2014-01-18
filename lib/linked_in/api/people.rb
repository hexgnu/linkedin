module LinkedIn
  module Api

    # People APIs
    #
    # @see http://developer.linkedin.com/documents/people People API
    # @see http://developer.linkedin.com/documents/profile-fields Profile Fields
    # @see http://developer.linkedin.com/documents/field-selectors Field Selectors
    module People

      # Retrieve a member's LinkedIn profile.
      #
      # Permissions: r_basicprofile, r_fullprofile
      #
      # @see http://developer.linkedin.com/documents/profile-api
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      # Retrieve a list of 1st degree connections for a user who has
      # granted access to his/her account
      #
      # Permissions: r_network
      #
      # @see http://developer.linkedin.com/documents/connections-api
      #
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      # TODO can't find this method in the REST API documentation and it
      # doesn't seem to work when I tried it out from the command line
      def picture_urls(options={})
        picture_size = options.delete(:picture_size) || 'original'
        path = "#{picture_urls_path(options)}::(#{picture_size})"
        simple_query(path, options)
      end
    end
  end
end
