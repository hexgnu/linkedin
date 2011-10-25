module LinkedIn
  class Client
    module Job

      # Returns detailed information about the job posting.
      #
      # @see https://developer.linkedin.com/documents/job-lookup-api-and-fields
      # @param id [Integer] Retreive the job using the ID
      # @param options [Hash] A customizable set of options.
      # @option options fields [Hash] A list of company fields
      # @return [Hashie::Rash]
      # @example
      #   client.job(1337)
      #   client.job(1337,:fields => ['id','company','posting-date'])
      def job(id,options={},params={})
        path = job_path(id,options)
        path = simple_query(path,options)
        get(path,params)
      end

      # Returns a list of bookmarked jobs for the user.
      #
      # @see https://developer.linkedin.com/documents/job-bookmarks-and-suggestions
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Rash]
      # @example
      #   client.job_bookmarks
      def job_bookmarks(options={},params={})
        path = person_path(options)
        path += "/job-bookmarks"
        path = simple_query(path,options)
        get(path,params)
      end

      # Returns a list of suggested jobs for a user.
      #
      # @see https://developer.linkedin.com/documents/job-bookmarks-and-suggestions
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Rash]
      # @example
      #   client.job_suggestions
      def job_suggestions(options={},params={})
        path = person_path(options)
        path += "/suggestions/job-suggestions:(jobs)"
        path = simple_query(path,options)
        get(path,params)
      end

      # Searches for jobs across the Job Search API using keywords.
      #
      # @see https://developer.linkedin.com/documents/job-search-api
      # @param options [Hash] A customizable set of options.
      # @option options keyword [Hash]  Jobs that have all the keywords anywhere in their listing. Multiple words should be separated by a space.
      # @option options company_name [Hash] Jobs with a matching company name.
      # @option options job_title [Hash] Matches jobs with the same job title.
      # @option options country_code [Hash] Matches jobs with a location in a specific country. Values are defined in by ISO 3166 standard. Country codes must be in all lower case.
      # @option options postal_code [Hash] Matches jobs centered around a Postal Code.
      # @option options distance [Hash] Matches jobs within a distance from a central point.
      # @option options facet [Hash] Facet values to search over.
      # @option options facets [Hash] Facet buckets to return.
      # @option options start [Hash] Start location within the result set for paginated returns.
      # @option options count [Hash] The number of jobs to return
      # @option options sort [Hash] Controls the search result order.
      # @return [Hashie::Rash]
      # @example
      #   client.job_search
      #   client.job_search(:keywords => "ruby")
      def job_search(options={})
        path = "job-search"
        get(path,options)
      end

      private
        def job_path(id,options)
          path = "jobs/#{id}"
        end
    end
  end
end

