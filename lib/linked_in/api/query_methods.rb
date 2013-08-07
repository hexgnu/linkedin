module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def company(options = {})
        path   = company_path(options)
        simple_query(path, options)
      end

      def company_updates(options={})
        path = "#{company_path(options)}/updates"
        simple_query(path, options)
      end

      def company_statistics(options={})
        path = "#{company_path(options)}/company-statistics"
        simple_query(path, options)
      end

      def company_updates_comments(update_key, options={})
        path = "#{company_path(options)}/updates/key=#{update_key}/update-comments"
        simple_query(path, options)
      end

      def company_updates_likes(update_key, options={})
        path = "#{company_path(options)}/updates/key=#{update_key}/likes"
        simple_query(path, options)
      end

      def job(options = {})
        path = jobs_path(options)
        simple_query(path, options)
      end

      def job_bookmarks(options = {})
        path = "#{person_path(options)}/job-bookmarks"
        simple_query(path, options)
      end

      def job_suggestions(options = {})
        path = "#{person_path(options)}/suggestions/job-suggestions"
        simple_query(path, options)
      end

      def group_memberships(options = {})
        path = "#{person_path(options)}/group-memberships"
        simple_query(path, options)
      end

      def group_profile(options)
        path = group_path(options)
        simple_query(path, options)
      end

      def group_posts(options)
        path = "#{group_path(options)}/posts"
        simple_query(path, options)
      end

      def shares(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, {:type => "SHAR", :scope => "self"}.merge(options))
      end

      def share_comments(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/update-comments"
        simple_query(path, options)
      end

      def share_likes(update_key, options={})
        path = "#{person_path(options)}/network/updates/key=#{update_key}/likes"
        simple_query(path, options)
      end
      
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
          path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
        end

        headers = options.delete(:headers) || {}
        params  = to_query(options)
        path   += "#{path.include?("?") ? "&" : "?"}#{params}" if !params.empty?

        Mash.from_json(get(path, headers))
      end

      def person_path(options)
        path = "/people/"
        if id = options.delete(:id)
          path += "id=#{id}"
        elsif url = options.delete(:url)
          path += "url=#{CGI.escape(url)}"
        else
          path += "~"
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
