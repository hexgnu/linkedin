module LinkedIn
  class Update < LinkedIn::Base

    %w[update_key update_type is_commentable?].each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./update/#{f.gsub(/_/,'-').gsub(/\?$/,"")}").text
      end
    end

    def timestamp
      @doc.xpath('./update/timestamp').text.to_i
    end

    def profile
      Profile.new(Nokogiri::XML(@doc.xpath('./update/update-content/person').to_xml))
    end

    def likes
      Likes.new(Nokogiri::XML(@doc.xpath('./update/likes').to_xml)).likes
    end

  end
end
