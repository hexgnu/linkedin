module LinkedIn
  class Country  < LinkedIn::Base

    def code
      @doc.xpath("/person/location/country/code").text
    end

  end
end
