module LinkedIn
  module Api

    module CompanyMethods

      # Get company's info. Fields returned by default: id and name
      # param:: options [Hash] a customizable set of options
      # options:: [String] :id The unique internal numeric company identifier
      # options:: [String] :universal_name The unique string identifier for a company
      # options:: [String] :email_domain Company email domains
      # options:: [Array] :fields Field Selectors to retrieve the additional fields
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
      
    end
  end
end
