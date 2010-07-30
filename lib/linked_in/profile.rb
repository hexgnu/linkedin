module LinkedIn
  class Profile < LinkedIn::Base

    # xml_reader :three_current_positions, :as => [Position]

    PROFILE_FIELDS = %w[id first_name last_name headline industry
                        current_status current_status_timestamp summary
                        specialties proposal_comments associations honors
                        interests picture_url distance num_recommenders]

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

    def education
      @education ||= Education.new(@doc.xpath('//educations')).education
    end

    def connections
      @connections ||= Connections.new(@doc.xpath('//connections')).connections
    end

    def groups
      @groups ||= Group.new(@doc.xpath('//member-groups')).groups
    end

  end
end
