module LinkedIn
  module Api

    # Groups API
    #
    # @see http://developer.linkedin.com/documents/groups-api Groups API
    # @see http://developer.linkedin.com/documents/groups-fields Groups Fields
    #
    # The following API actions do not have corresponding methods in
    # this module
    #
    #   * PUT Change my Group Settings
    #   * POST Change my Group Settings
    #   * DELETE Leave a group
    #   * PUT Follow/unfollow a Group post
    #   * PUT Flag a Post as a Promotion or Job
    #   * DELETE Delete a Post
    #   * DELETE Flag a post as inappropriate
    #   * DELETE A comment or flag comment as inappropriate
    #   * DELETE Remove a Group Suggestion
    #
    # [(contribute here)](https://github.com/hexgnu/linkedin)
    module Groups

      # Retrieve group suggestions for the current user
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
      # Permissions: rw_groups
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
      # Permissions: rw_groups
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

      # @deprecated Use {#add_group_share} instead
      def post_group_discussion(group_id, discussion)
        warn 'Use add_group_share over post_group_discussion. This will be taken out in future versions'
        add_group_share(group_id, discussion)
      end

      # Create a share for a company that the authenticated user
      # administers
      #
      # Permissions: rw_groups
      #
      # @see http://developer.linkedin.com/documents/groups-api#create
      #
      # @param [String] group_id Group ID
      # @macro share_input_fields
      # @return [void]
      def add_group_share(group_id, share)
        path = "/groups/#{group_id}/posts"
        post(path, MultiJson.dump(share), "Content-Type" => "application/json")
      end

      # (Update) User joins, or requests to join, a group
      #
      # @see http://developer.linkedin.com/documents/groups-api#membergroups
      #
      # @param [String] group_id Group ID
      # @return [void]
      def join_group(group_id)
        path = "/people/~/group-memberships/#{group_id}"
        body = {'membership-state' => {'code' => 'member' }}
        put(path, MultiJson.dump(body), "Content-Type" => "application/json")
      end
    end
  end
end
