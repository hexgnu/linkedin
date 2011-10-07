module LinkedIn
  class Client
    module Profile

      def profile
        get("/v1/people/~?format=json")
      end
    end
  end
end

