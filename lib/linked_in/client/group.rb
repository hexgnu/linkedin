module LinkedIn
  class Client
    module Group

     def group(id,options={})
        path = group_path(id,options)
        get(path, options)
      end

      private

        def group_path(id,options)
          path = "groups/#{id}"
        end
    end
  end
end

