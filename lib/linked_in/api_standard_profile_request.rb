module LinkedIn
  class ApiStandardProfileRequest

    def initialize(doc)
      @doc = doc
    end

    def url
      @doc.xpath("//api-standard-profile-request/url").text
    end

    # returning a hash should be ok, but suggestions are welcome
    def headers
      hash = {}
      hash[:name]  = @doc.xpath("//api-standard-profile-request/headers/http-header/name").text
      hash[:value] = @doc.xpath("//api-standard-profile-request/headers/http-header/value").text
      hash
    end
    
  end
end
