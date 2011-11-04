require 'json'

module LinkedIn

  module Search

    def search(options={})
      path = "/people-search"

      options = { :keywords => options } if options.is_a?(String)
			fields = options.delete :fields
      if !fields.nil? && fields.any?
        path +=":(people:(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')}),num-results)"
      end
      options = format_options_for_query(options)

      Mash.from_json(get_or_mock_search(to_uri(path, options)))
    end

    private

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
      
      def get_or_mock_search(uri)
      	puts "Search mocking"
      	if LinkedIn.mocking
      		s = YAML::load(File.open(File.expand_path("../../../mock/search_results.yml", __FILE__)))
      		s["people"]["_count"] = 2
      		s["people"]["values"] << YAML::load(File.open(File.expand_path("../../../mock/profiles/obama.yml", __FILE__)))
      		s["people"]["values"] << YAML::load(File.open(File.expand_path("../../../mock/profiles/toto.yml", __FILE__)))
      		s.to_json
      	else
      		get(uri)
      	end
      end

  end

end
