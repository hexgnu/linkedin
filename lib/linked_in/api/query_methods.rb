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

	    def get_or_mock_profile(uri)
	    	if LinkedIn.mocking
	    		LinkedIn.mocker.answer(uri)
	    	else
	    		get(uri)
	    	end
	    end

      def simple_query(path, options={})
        fields = options[:fields] || LinkedIn.default_profile_fields

        if options[:public]
          path +=":public"
        elsif fields
          path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
        end

        Mash.from_json(get_or_mock_profile(path))
      end

    end

  end
end
