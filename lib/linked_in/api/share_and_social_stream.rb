module LinkedIn
  module Api

    # Share and Social Stream APIs
    #
    # @see http://developer.linkedin.com/documents/share-and-social-stream
    # @see http://developer.linkedin.com/documents/share-api Share API
    #
    # The following API actions do not have corresponding methods in
    # this module
    #
    #   * GET Network Statistics
    #   * POST Post Network Update
    #
    # [(contribute here)](https://github.com/hexgnu/linkedin)
    module ShareAndSocialStream

      # Retrieve the authenticated users network updates
      #
      # Permissions: rw_nus
      #
      # @see http://developer.linkedin.com/documents/get-network-updates-and-statistics-api
      # @see http://developer.linkedin.com/documents/network-update-types Network Update Types
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

      # TODO refactor to use #network_updates
      def shares(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, {:type => "SHAR", :scope => "self"}.merge(options))
      end

      # Retrieve all comments for a particular network update
      #
      # @note The first 5 comments are included in the response to #network_updates
      #
      # Permissions: rw_nus
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
      # Permissions: rw_nus
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

      # Create a share for the authenticated user
      #
      # Permissions: rw_nus
      #
      # @see http://developer.linkedin.com/documents/share-api
      #
      # @macro share_input_fields
      # @return [void]
      def add_share(share)
        path = "/people/~/shares"
        defaults = {:visibility => {:code => "anyone"}}
        post(path, MultiJson.dump(defaults.merge(share)), "Content-Type" => "application/json")
      end

      # Create a comment on an update from the authenticated user
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] update_key a update/update-key representing a
      #   particular network update
      # @param [String] comment The text of the comment
      # @return [void]
      def update_comment(update_key, comment)
        path = "/people/~/network/updates/key=#{update_key}/update-comments"
        body = {'comment' => comment}
        post(path, MultiJson.dump(body), "Content-Type" => "application/json")
      end

      # (Update) like an update as the authenticated user
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] update_key a update/update-key representing a
      #   particular network update
      # @return [void]
      def like_share(update_key)
        path = "/people/~/network/updates/key=#{update_key}/is-liked"
        put(path, 'true', "Content-Type" => "application/json")
      end

      # (Destroy) unlike an update the authenticated user previously
      # liked
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] update_key a update/update-key representing a
      #   particular network update
      # @return [void]
      def unlike_share(update_key)
        path = "/people/~/network/updates/key=#{update_key}/is-liked"
        put(path, 'false', "Content-Type" => "application/json")
      end
    end
  end
end
