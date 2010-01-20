module LinkedIn
  class Profile
    include ROXML
    xml_convention {|val| val.gsub("_","-") }
    xml_reader :id
    xml_reader :first_name
    xml_reader :last_name
    xml_reader :headline
    xml_reader :location, :as => Location
    xml_reader :industry
    xml_reader :distance, :as => Integer
    xml_reader :relation_to_viewer, :as => {:key => :name, :value => :content}
    xml_reader :num_recommenders, :as => Integer
    xml_reader :current_status
    xml_reader :current_status_timestamp
    xml_reader :connections, :as => [Profile], :from => "connections/person"
    xml_reader :summary
    xml_reader :specialties
    xml_reader :proposal_comments
    xml_reader :associations
    xml_reader :honors
    xml_reader :interests
    xml_reader :positions, :as => [Position]
    xml_reader :education, :as => [Education]
    xml_reader :three_current_positions, :as => [Position]
    xml_reader :member_url_resources, :as => [UrlResource], :from => 'member-url-resources/member-url'
    xml_reader :api_standard_profile_request
    xml_reader :site_standard_profile_request, :as => ApiStandardProfileRequest
    xml_reader :picture_url

  end
end
