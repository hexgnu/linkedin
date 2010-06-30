module LinkedIn
  class Country

    def initialize(doc)
      @doc = doc
    end

    def code
      @doc.xpath("/person/location/country/code").text
    end

  end
end
