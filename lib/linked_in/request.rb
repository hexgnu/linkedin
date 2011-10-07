module LinkedIn
  module Request
    def get(path, options={})
      request(:get, path, options)
    end

    def post(path, options={})
      request(:post, path, options)
    end

    private

    def request(method, path, options)
      response = connection.send(method) do |request|
        case method
          when :get
            request.url(path, options)
          when :post
            request.path = path
            request.body = options unless options.empty?
          end
      end
      response.body
    end
  end
end
