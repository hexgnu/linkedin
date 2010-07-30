module LinkedIn
  class People < LinkedIn::Base

    %w[total start count].each do |f|
      define_method(f.to_sym) do
        @doc.xpath('.//people').first["#{f.gsub(/_/,'-')}"].to_i
      end
    end

    def profiles
      @array ||= begin
        @array = []
        @doc.xpath('//people').children.each do |profile|
          @array << Profile.new(Nokogiri::XML(profile.to_xml)) unless profile.blank?
        end
        @array
      end
    end

  end
end
