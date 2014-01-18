module LinkedIn
  module Api

    module UpdateMethods

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
        post(path, defaults.merge(share).to_json, "Content-Type" => "application/json")
      end

      # Create a share for a company that the authenticated user
      # administers
      #
      # Permissions: rw_company_admin
      #
      # @see http://developer.linkedin.com/creating-company-shares
      #
      # @param [String] company_id Company ID
      # @macro share_input_fields
      # @return [void]
      def add_company_share(company_id, share)
        path = "/companies/#{company_id}/shares"
        defaults = {:visibility => {:code => "anyone"}}
        post(path, defaults.merge(share).to_json, "Content-Type" => "application/json")
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
        post(path, share.to_json, "Content-Type" => "application/json")
      end

      # (Create) authenticated user starts following a company
      #
      # @see http://developer.linkedin.com/documents/company-follow-and-suggestions
      #
      # @param [String] company_id Company ID
      # @return [void]
      def follow_company(company_id)
        path = "/people/~/following/companies"
        body = {:id => company_id }
        post(path, body.to_json, "Content-Type" => "application/json")
      end

      # (Destroy) authenticated user stops following a company
      #
      # @see http://developer.linkedin.com/documents/company-follow-and-suggestions
      #
      # @param [String] company_id Company ID
      # @return [void]
      def unfollow_company(company_id)
        path = "/people/~/following/companies/id=#{company_id}"
        delete(path)
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
        put(path, body.to_json, "Content-Type" => "application/json")
      end

      # Create a job bookmark for the authenticated user
      #
      # @see http://developer.linkedin.com/documents/job-bookmarks-and-suggestions
      #
      # @param [String] bookmark Job ID
      # @return [void]
      def add_job_bookmark(bookmark)
        path = "/people/~/job-bookmarks"
        body = {'job' => {'id' => bookmark}}
        post(path, body.to_json, "Content-Type" => "application/json")
      end

      # Create a comment on an update from the authenticated user
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] network_key a update/update-key representing a
      #   particular network update
      # @param [String] comment The text of the comment
      # @return [void]
      def update_comment(network_key, comment)
        path = "/people/~/network/updates/key=#{network_key}/update-comments"
        body = {'comment' => comment}
        post(path, body.to_json, "Content-Type" => "application/json")
      end

      # (Update) like an update as the authenticated user
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] network_key a update/update-key representing a
      #   particular network update
      # @return [void]
      def like_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        put(path, 'true', "Content-Type" => "application/json")
      end

      # (Destroy) unlike an update the authenticated user previously
      # liked
      #
      # @see http://developer.linkedin.com/documents/commenting-reading-comments-and-likes-network-updates
      #
      # @param [String] network_key a update/update-key representing a
      #   particular network update
      # @return [void]
      def unlike_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        put(path, 'false', "Content-Type" => "application/json")
      end

      # (Create) send a message from the authenticated user to a
      # connection
      #
      # Permissions: w_messages
      #
      # @see http://developer.linkedin.com/documents/messaging-between-connections-api
      #
      # @example
      #   client.send_message(
      #     'What's New?',
      #     'Hi, what is going on with you two?',
      #     ['id=1234', 'id=5678']
      #   )
      #
      # @param [String] subject Subject of the message
      # @param [String] body Body of the message, plain text only
      # @param [Array<String>] recipient_paths a collection of
      #  profile paths that identify the users who will receive the
      #  message
      # @return [void]
      def send_message(subject, body, recipient_paths)
        path = "/people/~/mailbox"

        message = {
            'subject' => subject,
            'body' => body,
            'recipients' => {
                'values' => recipient_paths.map do |profile_path|
                  { 'person' => { '_path' => "/people/#{profile_path}" } }
                end
            }
        }
        post(path, message.to_json, "Content-Type" => "application/json")
      end

    end

  end
end
