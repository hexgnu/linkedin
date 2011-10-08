module LinkedIn
  class Client
    module Profile

      def profile(options={})
        response = get(person_path(options), options)
      end

      private
        def person_path(options)
          path = "people/"
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

