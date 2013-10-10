module LinkedIn
  module Api

    module UpdateMethods

      def add_share(share)
        path = "/people/~/shares"
        defaults = {:visibility => {:code => "anyone"}}
        post(path, defaults.merge(share).to_json, "Content-Type" => "application/json")
      end

      def join_group(group_id)
        path = "/people/~/group-memberships/#{group_id}"
        body = {'membership-state' => {'code' => 'member' }}
        put(path, body.to_json, "Content-Type" => "application/json")
      end

      def add_job_bookmark(bookmark)
        path = "/people/~/job-bookmarks"
        body = {'job' => {'id' => bookmark}}
        post(path, body.to_json, "Content-Type" => "application/json")
      end

      def update_comment(network_key, comment)
        path = "/people/~/network/updates/key=#{network_key}/update-comments"
        body = {'comment' => comment}
        post(path, body.to_json, "Content-Type" => "application/json")
      end

      def like_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        put(path, 'true', "Content-Type" => "application/json")
      end

      def unlike_share(network_key)
        path = "/people/~/network/updates/key=#{network_key}/is-liked"
        put(path, 'false', "Content-Type" => "application/json")
      end

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

      def post_group_discussion(group_id, discussion)
        path = "/groups/#{group_id}/posts"

        discussion_post = {
          'title' => discussion['title'],
          'summary' => discussion['summary']
        }

        post(path, discussion_post.to_json, "Content-Type" => "application/json")
      end

      # post_company_share
      #
      # Posts a company share to LinkedIn
      # https://developer.linkedin.com/creating-company-shares
      #
      # Parameters:
      #   - company_id: LinkedIn Company ID
      #   - content: Hash, for example:
      #     {
      #       "visibility" => { "code" => "anyone" },
      #       "comment" => "Testing a full company share!",
      #       "content" => {
      #         "submitted-­url" => "http =>//www.example.com/content.html",
      #         "title" => "Test Share with Content",
      #         "description" => "content description",
      #         "submitted‐image-­url" => "http://www.example.com/image.jpg"
      #       }
      #     }
      def post_company_share(company_id, share)
        path = "/companies/#{company_id}/shares"
        defaults = {:visibility => {:code => "anyone"}}
        post(path, defaults.merge(share).to_json, "Content-Type" => "application/json")
      end
    end

  end
end
