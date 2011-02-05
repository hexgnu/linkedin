module LinkedIn
  class People < LinkedIn::Base

    %w[total start count].each do |f|
      define_method(f.to_sym) do
        @doc.xpath('.//people').first["#{f.gsub(/_/,'-')}"].to_i
      end
    end

    def profiles
      @profiles ||= @doc.xpath('//people').children.inject([]) do |list, profile|
        list << Profile.new(Nokogiri::XML(profile.to_xml)) unless profile.blank?
        list
      end
    end

  end
end
