module LinkedIn
  class Client
    module Company

     def company(options={})
        path = company_path(options)
        get(path)
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
          else
            path
          end
        end
    end
  end
end

