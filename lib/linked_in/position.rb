module LinkedIn
  class Position
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :id
    xml_reader :title
    xml_reader :summary
    xml_reader :start_year, :from => "start-date/year", :as => Integer
    xml_reader :start_month, :from => "start-date/month", :as => Integer
    xml_reader :end_year, :from => "end-date/year", :as => Integer
    xml_reader :end_month, :from => "end-date/month", :as => Integer
    xml_reader :is_current
    xml_reader :company, :as => Company
  end
end
