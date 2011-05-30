module LinkedIn
  module Api

    module CompanyMethods

      # Get company's info. 
      # param:: options [Hash] A customizable set of options.
      # options:: [String] :id The unique internal numeric company identifier.
      # options:: [String] :universal_name The unique string identifier for a company.
      # options:: [String] :email_domain Company email domains.
      # options:: [Array] :fields Field Selectors to retrieve the additional fields. Fields returned by default: id and name.
      # result:: [LinkedIn::Mash]
      # see:: http://developer.linkedin.com/docs/DOC-1259
      #
      def company(options={})
        path = "/companies/"
        
        # retrieve companies by email domain
        if options[:email_domain]
          path = path.chomp('/') + "?email-domain=#{options[:email_domain]}"
        else
          # retrieve company by id or universal name identification
          if options[:id]
            path += options[:id]
          elsif options[:universal_name]
            path += "universal-name=#{options[:universal_name]}"
          end
          # define fields to retrieve 
          path += field_selector(options[:fields]) if options[:fields]
        end
        
        Mash.from_json(get(path))
      end
      
      # Search for companies. 
      # param:: keywords [String] Companies that have all the keywords anywhere in their listing. Multiple words should be separated by a space.
      # param:: options [Hash] A customizable set of options.
      # options:: [String] :start Start location within the result set for paginated returns. Default value is 0.
      # options:: [String] :count The number of companies to return. Default value is 10.
      # options:: [String] :order Controls the search result order (relevance, relationship, followers, company-size). Default value is relevance.
      # options:: [Array] :fields Field Selectors to retrieve the additional fields. Fields returned by default: id and name.
      # result:: [LinkedIn::Mash]
      # see:: http://developer.linkedin.com/docs/DOC-1325
      #
      def company_search(keywords, options={})
        path = "/company-search"
        
        fields = options.delete(:fields)
        path += field_selector(fields) if fields
        
        options[:keywords] = keywords
        options = format_options_for_query(options)
        
        result_json = get(to_uri(path, options))
        Mash.from_json(result_json)
      end
      
    end
  end
end
