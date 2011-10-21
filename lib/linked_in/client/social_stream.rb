module LinkedIn
  class Client
    module SocialStream

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def current_share(options={})
        path = "#{person_path(options)}:(current-share)"
        get(path,options)
      end

    end
  end
end

