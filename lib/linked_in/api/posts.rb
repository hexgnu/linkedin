module LinkedIn
  module Api

    # Posts APIs
    #
    # @see https://developer.linkedin.com/documents/groups-api
    module Posts

      # Get all posts comments
      #
      # Permissions: rw_groups
      #
      # @param [String] post_id ID of the post you want to interact with
      # @return [LinkedIn::Mash]
      def comments(post_id)
        simple_query("/posts/#{post_id}/comments")
      end

      # Get all posts likes
      #
      # Permissions: rw_groups
      #
      # @param [String] post_id ID of the post you want to interact with
      # @return [LinkedIn::Mash]
      def likes(post_id)
        simple_query("/posts/#{post_id}/likes")
      end

    end

  end
end
