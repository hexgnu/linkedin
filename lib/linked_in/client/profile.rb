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
      def profile(options={},params={})
        path = person_path(options)
        path = simple_query(path, options)
        get(path, params)
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
      def connections(options={},params={})
        path = "#{person_path(options)}/connections"
        path = simple_query(path, options)
        get(path,params)
      end

      # Use the People Search API to find people using keywords, company, name, or other criteria. It returns a list of matching member profiles.
      #
      # @see https://developer.linkedin.com/documents/people-search-api
      # @param options [Hash] A customizable set of options.
      # @option options keywords [String] Keywords for anywhere in the profile.
      # @option options first_name [String] Members with a matching first name.
      # @option options last_name [String] Members with a matching last name.
      # @option options company_name [String] Members who have a matching company name on their profile.
      # @option options current_company [String] Valid values are true or false. A value of true matches members who currently work at the company specified in the company-name parameter
      # @option options title [String] Matches members with that title on their profile.
      # @option options current_title [String] Valid values are true or false. A value of true matches members whose title is currently the one specified in the title-name parameter.
      # @option options school_name [String] Members who have a matching school name on their profile.
      # @option options current_school [String] Valid values are true or false. A value of true matches members who currently attend the school specified in the school-name parameter.
      # @option options country_code [String] Matches members with a location in a specific country. Values are defined in by ISO 3166 standard - http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements Country codes must be in all lower case.
      # @option options postal_code [String] Matches members centered around a Postal Code.
      # @option options distance [String] Matches members within a distance from a central point.
      # @option options facet [String] Facet values to search over.
      # @option options facets [String] Facet buckets to return.
      # @option options start [String] Start location within the result set for paginated returns.
      # @option options count [String] Ranges are specified with a starting index and a number of results to return. You may specify any number. Default and max page size is 500. Implement pagination to retrieve more than 500 connections.
      # @option options sort [String] Controls the search result order. Options: connections, recommenders, distance, relevance.
      # @return [Hashie::Rash]
      # @example
      #   client.search(:keyword => "ruby")
      def search(options={})
        path = "people-search"

        options = { :keywords => options } if options.is_a?(String)
        options = format_options_for_query(options)

        get(path,options)
      end

      private

        def simple_query(path, options={})
          fields = options[:fields] || self.default_profile_fields

          if options[:public]
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end

          path

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

        def format_options_for_query(opts)
          opts.inject({}) do |list, kv|
            key, value = kv.first.to_s.gsub("_","-"), kv.last
            list[key]  = sanitize_value(value)
            list
          end
        end

        def sanitize_value(value)
          value = value.join("+") if value.is_a?(Array)
          value = value.gsub(" ", "+") if value.is_a?(String)
          value
        end

    end
  end
end

