module LinkedIn
  class Update < LinkedIn::Base
    
    def update_type
      @doc.xpath('.update/update-type').text
    end
    
    def is_commentable?
      @doc.xpath("./update/is-commentable").text == "true"
    end

    def timestamp
      @doc.xpath('./update/timestamp').text.to_i
    end
    
  end
end
