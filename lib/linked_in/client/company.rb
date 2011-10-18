module LinkedIn
  class Client
    module Company

      # Returns the Company Profile based on ID, Universal Name, or Email domain.
      #
      # @see https://developer.linkedin.com/documents/company-lookup-api-and-fields
      # @param options [Hash] A customizable set of options.
      # @option options id [Hash] Retreive a company using the Company ID
      # @option options universal_name [Hash] Retreive a company using the Universal Name
      # @option options email_domain [Hash] Retreive an array of companies that match the email domain
      # @option options fields [Hash] A list of company fields
      # @return [Hashie::Rash]
      # @example
      #   client.company(:id => 660862)
      #   client.company(:universal_name => "linkedin")
      #   client.company(:email_domain => "apple.com")
      #   client.company(:id => "660862",:fields => ['id','name','ticker','description'])
      def company(options={})
        path = company_path(options)
        simple_query(path, options)
      end

      # Returns the companies that a user follows.
      #
      # @see https://developer.linkedin.com/documents/company-follow-and-suggestions
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Rash]
      # @example
      #   client.following_companies
      def following_companies(options={})
        path = person_path(options)
        path += "/following/companies"
        simple_query(path, options)
      end

      def suggested_companies(options={})
        path = person_path(options)
        path += "/suggestions/to-follow/companies"
        simple_query(path,options)
      end


      private

        def company_path(options)
          path = "companies"
          if options[:id]
            path += "/#{options[:id]}"
          elsif options[:universal_name]
            path += "/universal-name=#{options[:universal_name]}"
          elsif options[:email_domain]
            path += "?email-domain=#{options[:email_domain]}"
          end
        end
    end
  end
end

