module LinkedIn
  class Country
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :code
  end
end