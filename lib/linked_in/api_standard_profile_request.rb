module LinkedIn
  class ApiStandardProfileRequest
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :url
    xml_reader :headers, :as => {:key => 'name', :value => 'value'}, :in => 'headers/http-header'
    
  end
end
