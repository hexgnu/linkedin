module LinkedIn
  class Update
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :timestamp, :as => Integer
    xml_reader :update_key
    xml_reader :update_type
    xml_reader :profile, :as => Profile, :from => 'update-content/person'
    xml_reader :is_commentable?
  end
end