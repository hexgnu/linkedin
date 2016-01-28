module LinkedIn
  module Helpers

    module Request

      protected

      def get(path, query_params, headers = {})
        response = connection.get('v1/' + path, query_params, headers)
        response.body
      end

      def post(path, body='', options={})
        response = connection.post('v1/' + path, body, options)
        response
      end

      def put(path, body, options={})
        response = connection.put('v1/' + path, body, options)
        response
      end

      def delete(path, options={})
        response = connection.delete('v1/' + path, options)
        response
      end
    end
  end
end
