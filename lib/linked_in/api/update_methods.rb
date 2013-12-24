module LinkedIn
  module Api

    module UpdateMethods

      def add_share(share)
        path = "/people/~/shares"
        defaults = {:visibility => {:code => "anyone"}}
        post(path, defaults.merge(share).to_json, "Content-Type" => "application/json")
      end

      # Creates a company share
      # 
      # Returns an HttpResponse object with a body containing update_key and update_url
      # 
      # @param company_id [String] The company id
      # @param share [Hash] Share data
      # 
      # @option share [String] comment  Post must contain comment and/or (content/title and content/submitted-url). Max length is 700 characters.
      # @option share [Hash] content Content Hash
      # @option content [String] title Post must contain comment and/or (content/title and content/submitted-url). Max length is 200 characters.
      # @option content [String] submitted-url Post must contain comment and/or (content/title and content/submitted-url).
      # @option content [String] submitted-image-url Invalid without (content/title and content/submitted-url).
      # @option content [String] description Max length of 256 characters.
      # @option share [Hash] targets Hash containing target_code => ['target_value', ...]
      # 
      # @return [HttpResponse] Response
      def add_company_share(company_id, share)
        path = "/companies/#{company_id}/shares"
        defaults = {:visibility => {:code => "anyone"}}
        hashify post(path, render(:company_share, defaults.merge(share)), 'x-li-format' => 'xml', "Content-Type" => "application/xml")
      end

      def follow_company(company_id)
        path = "/people/~/following/companies"
        body = {:id => company_id }
        post(path, body.to_json, "Content-Type" => "application/json")
      end

      def unfollow_company(company_id)
        path = "/people/~/following/companies/id=#{company_id}"
        delete(path)
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
        post(path, discussion.to_json, "Content-Type" => "application/json")
      end

      private

      def hashify response
        response.body = Mash.from_response response
        response
      end

    end

  end
end
