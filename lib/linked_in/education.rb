module LinkedIn
  class Education
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :id
    xml_reader :school_name
    xml_reader :degree
    xml_reader :field_of_study
    xml_reader :activities
    xml_reader :start_year, :from => "start-date/year", :as => Integer
    xml_reader :start_month, :from => "start-date/month", :as => Integer
    xml_reader :end_year, :from => "end-date/year", :as => Integer
    xml_reader :end_month, :from => "end-date/month", :as => Integer
  end
end