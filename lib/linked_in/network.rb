module LinkedIn
  class Network
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :updates, :as => [Update]
  end
end