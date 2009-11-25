module LinkedIn
  class Connections
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :profiles, :as => [Profile], :from => 'person'
  end
end