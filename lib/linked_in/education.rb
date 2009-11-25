module LinkedIn
  class Education
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :id
    xml_reader :school_name
    xml_reader :degree
    xml_reader :start_date, :as => {:key => :name, :value => :content}
    xml_reader :end_date, :as => {:key => :name, :value => :content}
  end
end