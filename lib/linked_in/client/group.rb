module LinkedIn
  class Client
    module Group

      # Returns the information about the Group
      #
      # @see https://developer.linkedin.com/documents/groups-api
      # @param id [Integer] Retreive a Group using the Group ID
      # @param options [Hash] A customizable set of options.
      # @option options fields [Hash] A list of company fields
      # @return [Hashie::Rash]
      # @example
      #   client.group(120725)
      #   client.company_products(120725,:fields => :fields => ['id','name','site-group-url','posts'])
      def group(id,options={},params={})
        path = group_path(id,options)
        path = simple_query(path,options)
        get(path,params)
      end

      private
        def group_path(id,options)
          path = "groups/#{id}"
        end
    end
  end
end

