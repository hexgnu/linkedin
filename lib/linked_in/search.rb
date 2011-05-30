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

  end

end