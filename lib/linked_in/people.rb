module LinkedIn
  class People
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :total, :as => Integer, :from => "@total"
    xml_reader :start, :as => Integer, :from => "@start"
    xml_reader :count, :as => Integer, :from => "@count"
    xml_reader :profiles, :as => [Profile], :from => 'person'
  end
end