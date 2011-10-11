module LinkedIn
  class Client
    module Profile

      # Returns the member's LinkedIn profile.
      #
      # @see https://developer.linkedin.com/documents/profile-api
      # @param options [Hash] A customizable set of options.
      # @option options fields [Hash] A list of profile fields
      # @return [Hashie::Rash]
      # @example
      #   client.profile
      #   client.profile(:fields => ['educations'])
      #   client.profile(:fields => ['educations','positions'])
      #   client.profile(:id => "123")
      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      # Returns the list of connections for a user who has granted access to his/her account
      #
      # @see https://developer.linkedin.com/documents/connections-api
      # @param options [Hash] A customizable set of options.
      # @option options start [String] Starting location within the result set for paginated returns. Ranges are specified with a starting index and a number of results (count) to return. The default value for this parameter is 0.
      # @option options count [String] Ranges are specified with a starting index and a number of results to return. You may specify any number. Default and max page size is 500. Implement pagination to retrieve more than 500 connections.
      # @option options modified [String] Values are updated or new.
      # @option options modified-since [String] Value as a Unix time stamp of milliseconds since epoch.
      # @return [Hashie::Rash]
      # @example
      #   client.connections
      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end


      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      private

        def simple_query(path, options={})
          fields = options[:fields] || self.default_profile_fields

          if options[:public]
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end

          get(path)
        end

        def person_path(options)
          path = "people/"
          if options[:id]
            path += "id=#{options[:id]}"
          elsif options[:url]
            path += "url=#{CGI.escape(options[:url])}"
          else
            path += "~"
          end
        end
    end
  end
end

