module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def company(options = {})
        path = company_path(options)
        simple_query(path, options)
      end

################################################################################

      private

################################################################################

      def format_options_for_query(opts)
        opts.inject({}) do |list, kv|
          key, value = kv.first.to_s.gsub("_","-"), kv.last
          list[key]  = sanitize_value(value)
          list
        end
      end
  
      def sanitize_value(value)
        value = value.join("+") if value.is_a?(Array)
        value = value.gsub(" ", "+") if value.is_a?(String)
        value
      end

      def simple_query(path, options={})
        fields = options[:fields] || LinkedIn.default_profile_fields

        if options[:public]
          path +=":public"
        elsif fields
          path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
        end
        
        options = format_options_for_query(options)

        Mash.from_json(get_or_mock_query(to_uri(path, options)))
      end

    end

  end
end
