module LinkedIn
  class Client
    module SocialStream

      # Returns the current share for the current user.
      #
      # @see https://developer.linkedin.com/documents/share-apis
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Rash]
      # @example
      #   client.current_share
      def current_share(options={})
        path = "#{person_path(options)}:(current-share)"
        get(path,options)
      end

      # Return information about the member's network.
      #
      # @see https://developer.linkedin.com/documents/get-network-updates-and-statistics-api
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Rash]
      # @example
      #   client.network_stats
      def network_stats(options={})
        path = "#{person_path(options)}/network/network-stats"
        get(path,options)
      end

      # Returns a feed of network events.
      #
      # @see https://developer.linkedin.com/documents/get-network-updates-and-statistics-api
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Rash]
      # @example
      #   client.network_updates
      def network_updates(options={},params={})
        path = "#{person_path(options)}/network/updates"
        path = simple_query(path, options)
        get(path,params)
      end
    end
  end
end

