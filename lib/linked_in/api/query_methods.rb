module LinkedIn
  module Api

    module QueryMethods

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

      # Retrieve the authenticated users network updates
      #
      # TODO Permissions?
      #
      # @see http://developer.linkedin.com/documents/get-network-updates-and-statistics-api
      #
      # @macro person_path_options
      # @option options [String] :scope
      # @option options [String] :type
      # @option options [String] :count
      # @option options [String] :start
      # @option options [String] :after
      # @option options [String] :before
      # @option options [String] :show-hidden-members
      # @return [LinkedIn::Mash]
      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      # Retrieve a Company Profile
      #
      # @see http://developer.linkedin.com/documents/company-lookup-api-and-fields
      #
      # @macro company_path_options
      # @option options [String] :scope
      # @option options [String] :type
      # @option options [String] :count
      # @option options [String] :start
      # @return [LinkedIn::Mash]
      def company(options = {})
        path   = company_path(options)
        simple_query(path, options)
      end

      # Retrieve a feed of event items for a Company
      #
      # @see http://developer.linkedin.com/reading-company-shares
      #
      # @macro company_path_options
      # @option options [String] :event_type
      # @option options [String] :count
      # @option options [String] :start
      # @return [LinkedIn::Mash]
      def company_updates(options={})
        path = "#{company_path(options)}/updates"
        simple_query(path, options)
      end

      # Retrieve statistics for a particular company page
      #
      # Permissions: rw_company_admin
      #
      # @see http://developer.linkedin.com/documents/company-statistics
      #
      # @macro company_path_options
      # @return [LinkedIn::Mash]
      def company_statistics(options={})
        path = "#{company_path(options)}/company-statistics"
        simple_query(path, options)
      end

      # Retrieve comments on a particular company update:
      #
      # @see http://developer.linkedin.com/reading-company-shares
      #
      # @param [String] update_key a update/update-key representing a
      #   particular company update
      # @macro company_path_options
      # @return [LinkedIn::Mash]
      def company_updates_comments(update_key, options={})
        path = "#{company_path(options)}/updates/key=#{update_key}/update-comments"
        simple_query(path, options)
      end

      # Retrieve likes on a particular company update:
      #
      # @see http://developer.linkedin.com/reading-company-shares
      #
      # @param [String] update_key a update/update-key representing a
      #   particular company update
      # @macro company_path_options
      # @return [LinkedIn::Mash]
      def company_updates_likes(update_key, options={})
        path = "#{company_path(options)}/updates/key=#{update_key}/likes"
        simple_query(path, options)
      end

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

      # Retrieve job suggestions for the current user
      #
      # Permissions: r_fullprofile
      #
      # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
      #
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def group_suggestions(options = {})
        path = "#{person_path(options)}/suggestions/groups"
        simple_query(path, options)
      end

      # Retrieve the groups a current user belongs to
      #
      # Permissions: rw_groups
      #
      # @see http://developer.linkedin.com/documents/groups-api
      #
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def group_memberships(options = {})
        path = "#{person_path(options)}/group-memberships"
        simple_query(path, options)
      end

      # Retrieve the profile of a group
      #
      # Permissions: rw_groups TODO
      #
      # @see http://developer.linkedin.com/documents/groups-api
      #
      # @param [Hash] options identifies the group or groups
      # @optio options [String] :id identifier for the group
      # @return [LinkedIn::Mash]
      def group_profile(options)
        path = group_path(options)
        simple_query(path, options)
      end

      # Retrieve the posts in a group
      #
      # Permissions: rw_groups TODO
      #
      # @see http://developer.linkedin.com/documents/groups-api
      #
      # @param [Hash] options identifies the group or groups
      # @optio options [String] :id identifier for the group
      # @optio options [String] :count
      # @optio options [String] :start
      # @return [LinkedIn::Mash]
      def group_posts(options)
        path = "#{group_path(options)}/posts"
        simple_query(path, options)
      end

      # TODO refactor to use #network_updates
      def shares(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, {:type => "SHAR", :scope => "self"}.merge(options))
      end

      # Retrieve all comments for a particular network update
      #
      # @note The first 5 comments are included in the response to #network_updates
      #
      # TODO Permissions? rw_nus?
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] update_key a update/update-key representing a
      #   particular network update
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def share_comments(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/update-comments"
        simple_query(path, options)
      end

      # Retrieve all likes for a particular network update
      #
      # @note Some likes are included in the response to #network_updates
      #
      # TODO Permissions? rw_nus?
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] update_key a update/update-key representing a
      #   particular network update
      # @macro person_path_options
      # @return [LinkedIn::Mash]
      def share_likes(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/likes"
        simple_query(path, options)
      end

      # TODO can't find this method in the REST API documentation and it
      # doesn't seem to work when I tried it out from the command line
      def picture_urls(options={})
        picture_size = options.delete(:picture_size) || 'original'
        path = "#{picture_urls_path(options)}::(#{picture_size})"
        simple_query(path, options)
      end

      private

      def group_path(options)
        path = "/groups"
        if id = options.delete(:id)
          path += "/#{id}"
        end
      end

      def simple_query(path, options={})
        fields = options.delete(:fields) || LinkedIn.default_profile_fields

        if options.delete(:public)
          path +=":public"
        elsif fields
          path +=":(#{build_fields_params(fields)})"
        end

        headers = options.delete(:headers) || {}
        params  = to_query(options)
        path   += "#{path.include?("?") ? "&" : "?"}#{params}" if !params.empty?

        Mash.from_json(get(path, headers))
      end

      def build_fields_params(fields)
        if fields.is_a?(Hash) && !fields.empty?
          fields.map {|index,value| "#{index}:(#{build_fields_params(value)})" }.join(',')
        elsif fields.respond_to?(:each)
          fields.map {|field| build_fields_params(field) }.join(',')
        else
          fields.to_s.gsub("_", "-")
        end
      end

      def person_path(options)
        path = "/people"
        if id = options.delete(:id)
          path += "/id=#{id}"
        elsif url = options.delete(:url)
          path += "/url=#{CGI.escape(url)}"
        elsif email = options.delete(:email)
          path += "::(#{email})"
        else
          path += "/~"
        end
      end

      def company_path(options)
        path = "/companies"

        if domain = options.delete(:domain)
          path += "?email-domain=#{CGI.escape(domain)}"
        elsif id = options.delete(:id)
          path += "/id=#{id}"
        elsif url = options.delete(:url)
          path += "/url=#{CGI.escape(url)}"
        elsif name = options.delete(:name)
          path += "/universal-name=#{CGI.escape(name)}"
        elsif is_admin = options.delete(:is_admin)
          path += "?is-company-admin=#{CGI.escape(is_admin)}"
        else
          path += "/~"
        end
      end

      def picture_urls_path(options)
        path = person_path(options)
        path += "/picture-urls"
      end

      def jobs_path(options)
        path = "/jobs"
        if id = options.delete(:id)
          path += "/id=#{id}"
        else
          path += "/~"
        end
      end
    end
  end
end
