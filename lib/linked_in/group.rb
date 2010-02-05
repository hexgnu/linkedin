module LinkedIn
  class Group
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :id
    xml_reader :name
    xml_reader :site_group_request, :as => ApiStandardProfileRequest
  end
end