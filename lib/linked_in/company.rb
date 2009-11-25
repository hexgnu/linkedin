module LinkedIn
  class Company
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :type
    xml_reader :name
    xml_reader :industry
  end
end