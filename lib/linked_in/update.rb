module LinkedIn
  class Update < LinkedIn::Base
    
    # Elements shared by all updates
    def update_type
      @doc.xpath('./update/update-type').text
    end
    
    def timestamp
      @doc.xpath('./update/timestamp').text.to_i
    end
    
    def is_commentable?
      @doc.xpath('./update/is-commentable').text == "true"
    end
    
    # Elements shared only by some updates, hence the checking  
    def update_key
      key = @doc.xpath('./update/update-key')
      key.blank? ? nil : key.text
    end
    
    def profile
      person = @doc.xpath('./update/update-content/person')
      person.blank? ? nil : Profile.new(Nokogiri::XML(person.to_xml))
    end
      
    def is_likable?
      likable = @doc.xpath('./update/is-likable')
      likable.blank? ? false : likable.text == "true"
    end
    
    def is_liked?
      self.is_likable? ? @doc.xpath('./update/is-liked').text == "true" : nil
    end
    
    def likes
      Likes.new(Nokogiri::XML(@doc.xpath('./update/likes').to_xml)).likes
    end
    
    def updated_fields
      @updated_fields = @doc.xpath('./update/updated-fields').children.inject([]) do |list, update_field|
        list << update_field.xpath('//update-field/name').text unless update_field.blank?
        list
      end
    end
    
    def job
      Job.new(Nokogiri::XML(@doc.xpath('./update/update-content/job').to_xml))
    end
    
  end
end