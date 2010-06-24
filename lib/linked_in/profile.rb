module LinkedIn
  class Profile
    # include ROXML
    # xml_convention {|val| val.gsub("_","-") }
    # xml_reader :id
    # xml_reader :first_name
    # xml_reader :last_name
    # xml_reader :headline
    # xml_reader :location, :as => Location
    # xml_reader :industry
    # xml_reader :distance, :as => Integer
    # xml_reader :relation_to_viewer, :as => {:key => :name, :value => :content}
    # xml_reader :num_recommenders, :as => Integer
    # xml_reader :current_status
    # xml_reader :current_status_timestamp
    # xml_reader :connections, :as => [Profile], :from => "connections/person"
    # xml_reader :summary
    # xml_reader :specialties
    # xml_reader :proposal_comments
    # xml_reader :associations
    # xml_reader :honors
    # xml_reader :interests
    # xml_reader :positions, :as => [Position]
    # xml_reader :education, :as => [Education]
    # xml_reader :three_current_positions, :as => [Position]
    # xml_reader :member_url_resources, :as => [UrlResource], :from => 'member-url-resources/member-url'
    # xml_reader :api_standard_profile_request
    # xml_reader :site_standard_profile_request, :as => ApiStandardProfileRequest
    # xml_reader :picture_url

    FIELDS = %w[id first_name last_name headline industry current_status
                current_status_timestamp summary specialties proposal_comments
                associations honors interests picture_url distance
                num_recommenders]
    
    FIELDS.each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./person/#{f.gsub(/_/,'-')}").text
      end
    end
    
    def self.from_xml(doc)
      new(doc)
    end
    
    def initialize(doc)
      @doc = Nokogiri::XML(doc)
    end

    def location
      @location ||= Location.new(@doc.xpath('//location'))
    end
    
    def api_standard_profile_request
      @api_standard ||= ApiStandardProfileRequest.new(@doc.xpath('//api-standard-profile-request'))
    end
    
    def site_standard_profile_request
      api_standard_profile_request
    end
    
    def relation_to_viewer
      @doc.xpath('//relation-to-viewer/distance').text
    end
    
    def member_url_resources
      @url_resources ||= UrlResource.new(@doc.xpath('//member-url-resources'))
    end
    
    def positions
      @positions ||= Position.new(@doc.xpath('//positions')).positions
    end
    
  end
end
