module LinkedIn
  module Helpers

    module Request

      DEFAULT_HEADERS = {
        'x-li-format' => 'json'
      }

      API_PATH = '/v1'

      protected
      
        def get(path, options={})
          response = access_token.get("#{API_PATH}#{path}", DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response.body
        end

        def post(path, body='', options={})
          response = access_token.post("#{API_PATH}#{path}", body, DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response
        end

        def put(path, body, options={})
          response = access_token.put("#{API_PATH}#{path}", body, DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response
        end

        def delete(path, options={})
          response = access_token.delete("#{API_PATH}#{path}", DEFAULT_HEADERS.merge(options))
          raise_errors(response)
          response
        end

      private

        def raise_errors(response)
          # Even if the XML answer contains the HTTP status code, LinkedIn also sets this code
          # in the HTTP answer (thankfully).
          case response.code.to_i
          when 400
            data = LinkedIn::Error.from_xml(response.body)
            raise RateLimitExceeded.new(data), "(#{response.code}): #{response.message} - #{data.code if data}"
          when 401
            data = LinkedIn::Error.from_xml(response.body)
            raise Unauthorized.new(data), "(#{response.code}): #{response.message} - #{data.code if data}"
          when 403
            data = LinkedIn::Error.from_xml(response.body)
            raise General.new(data), "(#{response.code}): #{response.message} - #{data.code if data}"
          when 404
            raise NotFound, "(#{response.code}): #{response.message}"
          when 500
            raise InformLinkedIn, "LinkedIn had an internal error. Please let them know in the forum. (#{response.code}): #{response.message}"
          when 502..503
            raise Unavailable, "(#{response.code}): #{response.message}"
          end
        end

        def to_query(options)
          options.inject([]) do |collection, opt|
            collection << "#{opt[0]}=#{opt[1]}"
            collection
          end * '&'
        end

        def to_uri(path, options)
          uri = URI.parse(path)

          if options && options != {}
            uri.query = to_query(options)
          end
          uri.to_s
        end
    end

  end
end