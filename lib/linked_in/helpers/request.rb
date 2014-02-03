module LinkedIn
  module Helpers

    module Request

      protected

        def get(path, query_params, headers = {})
          response = connection.get('v1/' + path, query_params, headers)
          raise_errors(response)
          response.body
        end

        def post(path, body='', options={})
          response = connection.post('v1/' + path, body, options)
          raise_errors(response)
          response
        end

        def put(path, body, options={})
          response = connection.put('v1/' + path, body, options)
          raise_errors(response)
          response
        end

        def delete(path, options={})
          response = connection.delete('v1/' + path, options)
          raise_errors(response)
          response
        end

      private

        def raise_errors(response)
          # Even if the json answer contains the HTTP status code, LinkedIn also sets this code
          # in the HTTP answer (thankfully).
          case response.status.to_i
          when 401
            data = Mash.new(response.body)
            raise LinkedIn::Errors::UnauthorizedError.new(data), "(#{data.status}): #{data.message}"
          when 400
            data = Mash.new(response.body)
            raise LinkedIn::Errors::GeneralError.new(data), "(#{data.status}): #{data.message}"
          when 403
            data = Mash.new(response.body)
            raise LinkedIn::Errors::AccessDeniedError.new(data), "(#{data.status}): #{data.message}"
          when 404
            raise LinkedIn::Errors::NotFoundError, "(#{response.code}): #{response.message}"
          when 500
            raise LinkedIn::Errors::InformLinkedInError, "LinkedIn had an internal error. Please let them know in the forum. (#{response.code}): #{response.message}"
          when 502..503
            raise LinkedIn::Errors::UnavailableError, "(#{response.code}): #{response.message}"
          end
        end
    end

  end
end
