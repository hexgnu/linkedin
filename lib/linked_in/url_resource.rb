module LinkedIn
  class UrlResource
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :url
    xml_reader :name
  end
end