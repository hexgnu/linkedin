module LinkedIn

  module Search
    REJECT_KEYS = [:fields]

    # Retrieve search results of the given object type
    #
    # Permissions: (for people search only) r_network
    #
    # @note People Search API is a part of the Vetted API Access Program. You
    #   must apply and get approval before using this API
    #
    # @see http://developer.linkedin.com/documents/people-search-api People Search
    # @see http://developer.linkedin.com/documents/job-search-api Job Search
    # @see http://developer.linkedin.com/documents/company-search Company Search
    #
    # @param [Hash] options search input fields
    # @param [String] type type of object to return ('people', 'job' or 'company')
    # @return [LinkedIn::Mash]
    def search(options={}, type='people')

      path = "/#{type.to_s}-search"

      if options.is_a?(Hash)
        fields = options.fetch(:fields, [])
        if !fields.empty?
          path += field_selector(fields)
        else

        end
      elsif options.is_a?(String)
        options = {:keywords => options}
      else

      end

      options = format_options_for_query(options)

      result_json = get(to_uri(path, options))

      Mash.from_json(result_json)
    end

    private

      def format_options_for_query(opts)
        query_hash = {}

        opts.each do |k, value|
          if REJECT_KEYS.include?(k)
            next
          else
            key = k.to_s.gsub("_", "-")
            query_hash[key] = sanitize_value(value)
          end
        end

        query_hash
      end

      def sanitize_value(value)
        value = value.join("+") if value.is_a?(Array)
        value = value.gsub(" ", "+") if value.is_a?(String)
        value
      end

      def field_selector(fields)
        result = ":("
        fields = fields.to_a.map do |field|
          if field.is_a?(Hash)
            innerFields = []
            field.each do |key, value|
              innerFields << key.to_s.gsub("_","-") + field_selector(value)
            end
            innerFields.join(',')
          else
            field.to_s.gsub("_","-")
          end
        end
        result += fields.join(',')
        result += ")"
        result
      end
  end

end
