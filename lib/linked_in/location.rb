module LinkedIn
  class Location < LinkedIn::Base

    def name
      @doc.xpath("/person/location/name").text
    end

    def country
      @doc.xpath("/person/location/country/code").text
    end

  end
end
