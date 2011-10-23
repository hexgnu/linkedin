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

      private

        def simple_query(path, options={})
          fields = options[:fields] || LinkedIn.default_profile_fields

          if options[:public]
            path += ":public"
          elsif fields
            path += ":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end

          if options[:count] or options[:start]
            path += "?"
            path += "count=#{options[:count].to_i}" if options[:count]
            path += "&" if options[:count] and options[:start]
            path += "start=#{options[:start].to_i}" if options[:start]
          end

          Mash.from_json(get(path))
        end

        def person_path(options)
          path = "/people/"
          if options[:id]
            path += "id=#{options[:id]}"
          elsif options[:url]
            path += "url=#{CGI.escape(options[:url])}"
          else
            path += "~"
          end
        end

        def company_path(options)
          path = "/companies/"
          if options[:id]
            path += "id=#{options[:id]}"
          elsif options[:url]
            path += "url=#{CGI.escape(options[:url])}"
          else
            path += "~"
          end
        end

    end

  end
end