module LinkedIn
  class Error
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :status, :as => Integer
    xml_reader :timestamp, :as => Integer
    xml_reader :code, :as => Integer, :from => "error-code"
    xml_reader :message
  end
end