module LinkedIn

  module RequestHelpers

    def get(path, options={})
      path = "/v1#{path}"
      response = access_token.get(path, options)
      raise_errors(response)
      response.body
    end

    def post(path, body='', options={})
      path = "/v1#{path}"
      default_options = { 'Content-Type' => 'application/xml' }
      response = access_token.post(path, body, default_options.merge(options))
      raise_errors(response)
      response
    end

    def put(path, body, options={})
      path = "/v1#{path}"
      response = access_token.put(path, body, options)
      raise_errors(response)
      response
    end

    def delete(path, options={})
      path = "/v1#{path}"
      response = access_token.delete(path, options)
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
        query_string = options.inject([]) do |collection, opt|
          collection << "#{opt[0]}=#{opt[1]}"
          collection
        end * '&'
        URI.escape(query_string)
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