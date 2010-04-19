module LinkedIn
  class Recipient
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_accessor :person, :as => Person
  end
end
