module LinkedIn
  class Profile < LinkedIn::Base

    # xml_reader :three_current_positions, :as => [Position]

    PROFILE_FIELDS = %w[id first_name last_name headline industry
                        current_status current_status_timestamp summary
                        specialties proposal_comments associations honors
                        interests picture_url distance num_recommenders public_profile_url]

    PROFILE_FIELDS.each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./person/#{f.gsub(/_/,'-')}").text
      end
    end

    def location
      @location ||= Location.new(@doc)
    end

    def api_standard_profile_request
      @api_standard ||= ApiStandardProfileRequest.new(@doc.xpath('./person/api-standard-profile-request'))
    end

    def site_standard_profile_request
      @doc.xpath('//site-standard-profile-request/url').text
    end

    def relation_to_viewer
      @doc.xpath('//relation-to-viewer/distance').text
    end

    def member_url_resources
      @url_resources ||= UrlResource.new(@doc.xpath('//member-url-resources')).resources
    end

    def positions
      @positions ||= Position.new(@doc.xpath('//positions')).positions
    end

    def educations
      @educations ||= Education.new(@doc.xpath('//educations')).educations
    end

    def connections
      @connections ||= Connections.new(@doc.xpath('//connections')).connections
    end

    def groups
      @groups ||= Group.new(@doc.xpath('//member-groups')).groups
    end

    def recommendations
      @recommendations ||= Recommendations.new(@doc.xpath('//recommendations-received')).recommendations
    end

    def current_share
      @current_share ||= CurrentShare.new(@doc.xpath('//current-share'))
    end

    def languages
      @languages ||= Language.new(@doc.xpath('//languages')).languages
    end
    
    def skills
      @skills ||= Skill.new(@doc.xpath('//skills')).skills
    end
    
    def phone_numbers
      @phone_number ||= PhoneNumber.new(@doc.xpath('//phone-numbers')).phone_numbers
    end
    
    def publications
      @publication ||= Publication.new(@doc.xpath('//publications')).publications
    end
    
    def patents
      @patent ||= Patent.new(@doc.xpath('//patents')).patents
    end
  end
end
