module LinkedIn
  class Location
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :name
    xml_reader :country, :as => {:key => :name, :value => :content}
  end
end