module LinkedIn

  module Search

    def search(options={})
      path = "/people-search"
      options = { :keywords => options } if options.is_a?(String)
      
      if fields = options.delete(:fields)
        path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
      end
      
      options = format_options_for_query(options)

      result_json = get(to_uri(path, options))
      Mash.from_json(result_json)
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

  end

end
