module LinkedIn
  class Client
    module Company

     def company(id,options={})
        path = company_path(id,options)
        get(path, options)
      end

      private

        def company_path(id,options)
          path = "companies/#{id}"
        end
    end
  end
end

