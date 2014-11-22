module LinkedIn
  module Api

    module QueryHelpers
      REJECT_KEYS = [:fields, :headers, :public, :id, :url, :email, :is_admin, :domain, :name]

      private

      def group_path(options)
        path = "groups"
        if id = options[:id]
          path += "/#{id}"
        end
      end

      def simple_query(path, options={})
        fields = options.fetch(:fields, LinkedIn.default_profile_fields)

        if options[:public]
          path +=":public"
        elsif fields
          path +=":(#{build_fields_params(fields)})"
        end

        headers = options.fetch(:headers, {})
        # params  = to_query(options)
        # path   += "#{path.include?("?") ? "&" : "?"}#{params}" if !params.empty?

        query = options.reject { |k,v| REJECT_KEYS.include? k.to_sym }
        get(path, query, headers)
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
        path = "people"
        if id = options[:id]
          path += "/id=#{id}"
        elsif url = options[:url]
          path += "/url=#{CGI.escape(url)}"
        elsif email = options[:email]
          path += "::(#{email})"
        else
          path += "/~"
        end
      end

      def company_path(options)
        path = "companies"

        if domain = options[:domain]
          path += "?email-domain=#{CGI.escape(domain)}"

        elsif id = options[:id]
          path += "/#{id}"
        elsif url = options[:url]
          path += "/url=#{CGI.escape(url)}"
        elsif name = options[:name]
          path += "/universal-name=#{CGI.escape(name)}"
        elsif is_admin = options[:is_admin]
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
        path = "jobs"
        if id = options[:id]
          path += "/id=#{id}"
        else
          path += "/~"
        end
      end
    end
  end
end
