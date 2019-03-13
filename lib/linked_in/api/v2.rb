module LinkedIn
  module Api

    # V2 Consumer API
    #
    # @see https://docs.microsoft.com/en-us/linkedin/consumer/
    module V2

      # Obtain profile information for a member.  Currently, the method only
      # accesses the authenticated user.
      #
      # Permissions: r_liteprofile r_emailaddress
      #
      # @see https://docs.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin?context=linkedin/consumer/context#retrieving-member-profiles
      #
      # @return [void]
      def v2_profile
        path = '/me'
        v2_get(path)
      end

      # Share content for the authenticated user
      #
      # Permissions: w_member_share
      #
      # @see https://docs.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/share-on-linkedin
      #
      # @param [String] urn   User's URN (UID) returned from OAuth access token
      #                       request
      # @param [Hash]   share The body we want to submit to LinkedIn. At least a
      #                       comment is required
      #
      # @macro share_input_fields
      # @return [void]
      def v2_add_share(urn, share = {})
        if !urn.instance_of?(String) || urn.empty?
          raise LinkedIn::Errors::UnavailableError, 'LinkedIn API: URN required'
        elsif share[:comment].nil? && share[:url].nil?
          raise LinkedIn::Errors::UnavailableError,
                'LinkedIn API: At least a comment is required'
        end

        path = '/ugcPosts'
        v2_post(path, MultiJson.dump(share_payload(urn, share)))
      end

      private

        def share_payload(urn, share)
          payload = { author: "urn:li:person:#{urn}",
            lifecycleState: 'PUBLISHED',
            visibility: {
              'com.linkedin.ugc.MemberNetworkVisibility' => 'PUBLIC'
            }
          }

          return add_url_to_payload(payload, share) if share[:url]

          add_comment_to_payload(payload, share)
        end

        def add_url_to_payload(payload, share)
          media = { status: 'READY', originalUrl: share[:url] }
          if share[:description]
            media[:description] = { text: share[:description] }
          end
          if share[:title]
            media[:title] = { text: share[:title] }
          end
          payload[:specificContent] = {
            'com.linkedin.ugc.ShareContent' => {
              shareMediaCategory: 'ARTICLE',
              media: [media]
            }
          }
          if share[:comment]
            payload[:specificContent]['com.linkedin.ugc.ShareContent'][:shareCommentary] =
              { text: share[:comment] }
          end
          payload
        end

        def add_comment_to_payload(payload, share)
          payload[:specificContent] = {
            'com.linkedin.ugc.ShareContent' => {
              shareCommentary: { text: share[:comment] },
              shareMediaCategory: 'NONE'
            }
          }
          payload
        end
    end
  end
end
