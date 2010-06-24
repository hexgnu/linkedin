module LinkedIn
  class Location
    # include ROXML
    # xml_convention {|val| val.gsub("_","-") }
    # xml_reader :name
    # xml_reader :country, :as => {:key => :name, :value => :content}
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