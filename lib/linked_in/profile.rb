module LinkedIn
  class Profile

    # xml_reader :location, :as => Location
    # xml_reader :relation_to_viewer, :as => {:key => :name, :value => :content}

    # xml_reader :three_current_positions, :as => [Position]
    # xml_reader :member_url_resources, :as => [UrlResource], :from => 'member-url-resources/member-url'


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
      new(Nokogiri::XML(doc))
    end

    def initialize(doc)
      @doc = doc
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
    
    # TODO: make UrlResource act like Position and Education 
    def member_url_resources
      @url_resources ||= UrlResource.new(@doc.xpath('//member-url-resources'))
    end

    def positions
      @positions ||= Position.new(@doc.xpath('//positions')).positions
    end

    def education
      @education ||= Education.new(@doc.xpath('//educations')).education
    end
    
    def connections
      @connections ||= Connections.new(@doc.xpath('//connections')).connections
    end
    
  end
end
