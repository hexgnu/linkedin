module LinkedIn
  module Api

    # Jobs API
    #
    # @see http://developer.linkedin.com/documents/job-lookup-api-and-fields Job Lookup API and Fields
    # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions Job Bookmarks and Suggestions
    #
    # The following API actions do not have corresponding methods in
    # this module
    #
    #   * DELETE a Job Bookmark
    #
    # [(contribute here)](https://github.com/hexgnu/linkedin)
    module Jobs

      # Retrieve likes on a particular company update:
      #
      # @see http://developer.linkedin.com/reading-company-shares
      #
      # @param [Hash] options identifies the job
      # @option options [String] id unique identifier for a job
      # @return [LinkedIn::Mash]
      def job(options = {})
        path = jobs_path(options)
        simple_query(path, options)
      end

      # Retrieve the current members' job bookmarks
      #
      # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
      #
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def job_bookmarks(options = {})
        path = "#{person_path(options)}/job-bookmarks"
        simple_query(path, options)
      end

      # Retrieve job suggestions for the current user
      #
      # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
      #
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def job_suggestions(options = {})
        path = "#{person_path(options)}/suggestions/job-suggestions"
        simple_query(path, options)
      end

      # Create a job bookmark for the authenticated user
      #
      # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
      #
      # @param [String] job_id Job ID
      # @return [void]
      def add_job_bookmark(job_id)
        path = "/people/~/job-bookmarks"
        body = {'job' => {'id' => job_id}}
        post(path, MultiJson.dump(body), "Content-Type" => "application/json")
      end
    end
  end
end
