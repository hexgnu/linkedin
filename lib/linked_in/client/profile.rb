module LinkedIn
  class Client
    module Profile

      def profile(options)
        get("/v1/people/~")
      end
    end
  end
end

