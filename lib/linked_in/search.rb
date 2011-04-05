module LinkedIn

  module Search

    def search(options={})
      path = "/people-search"

      options = { :keywords => options } if options.is_a?(String)
      options = format_options_for_query(options)

      result_json = get(to_uri(path, options))

      Mash.from_json(result_json)
    end

    private

      def format_options_for_query(opts)
        Hash[
          opts.map do |kv|
            key, value = kv.first.to_s.gsub("_","-"), kv.last
            [key, sanitize_value(value)]
          end
        ]
      end

      def sanitize_value(value)
        case value
          when Array
            value.join("+")
          when String
            value.gsub(" ", "+")
          else
            value
        end
      end

  end

end
