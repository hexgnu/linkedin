module LinkedIn
  class Location

    def initialize(doc)
      @doc = doc
    end

    def name
      @doc.xpath("/person/location/name").text
    end

    def country
      @doc.xpath("/person/location/country/code").text
    end

  end
end
