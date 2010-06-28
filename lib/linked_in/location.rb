module LinkedIn
  class Location
    
    def initialize(doc)
      @doc = doc
    end

    def name
      @doc.xpath("//location/name").text
    end
    
    def country
      @doc.xpath("//location/country/code").text
    end
    
  end
end