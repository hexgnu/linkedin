module LinkedIn
  class Client
    module Profile

      def profile(options={})
        response = get('/v1/people/~', options)
      end
    end
  end
end

