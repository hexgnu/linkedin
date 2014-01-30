module LinkedIn
  module Api

    # Companies API
    #
    # @see http://developer.linkedin.com/documents/companies Companies API
    # @see http://developer.linkedin.com/documents/company-lookup-api-and-fields Company Fields
    #
    # The following API actions do not have corresponding methods in
    # this module
    #
    #   * Permissions Checking Endpoints for Company Shares
    #   * GET Suggested Companies to Follow
    #   * GET Company Products
    #
    # [(contribute here)](https://github.com/hexgnu/linkedin)
    module Companies

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
      # @option options [String] :event-type
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

      # Create a share for a company that the authenticated user
      # administers
      #
      # Permissions: rw_company_admin
      #
      # @see http://developer.linkedin.com/creating-company-shares
      # @see http://developer.linkedin.com/documents/targeting-company-shares Targeting Company Shares
      #
      # @param [String] company_id Company ID
      # @macro share_input_fields
      # @return [void]
      def add_company_share(company_id, share)
        path = "/companies/#{company_id}/shares"
        defaults = {:visibility => {:code => "anyone"}}
        post(path, MultiJson.dump(defaults.merge(share)), "Content-Type" => "application/json")
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
        post(path, MultiJson.dump(body), "Content-Type" => "application/json")
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
    end
  end
end
