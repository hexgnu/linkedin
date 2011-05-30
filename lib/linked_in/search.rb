module LinkedIn

  module Search

    def search(options={})
      path = "/people-search"

      if options.is_a?(Hash)
        fields = options.delete(:fields)
        path += field_selector(fields) if fields
      end
      
      options = { :keywords => options } if options.is_a?(String)
      options = format_options_for_query(options)

      result_json = get(to_uri(path, options))

      Mash.from_json(result_json)
    end

    private

      def format_options_for_query(opts)
        opts.inject({}) do |list, kv|
          key, value = kv.first.to_s.gsub("_","-"), kv.last
          list[key]  = sanatize_value(value)
          list
        end
      end

      def sanatize_value(value)
        value = value.join("+") if value.is_a?(Array)
        value = value.gsub(" ", "+") if value.is_a?(String)
        value
      end
      
  end

end