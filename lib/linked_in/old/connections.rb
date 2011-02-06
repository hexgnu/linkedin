module LinkedIn
  class Connections < LinkedIn::Base

    def connections
      @connections ||= @doc.xpath('//connections').children.inject([]) do |list, profile|
        list << Profile.new(Nokogiri::XML(profile.to_xml)) unless profile.blank?
        list
      end
    end

    def profiles
      connections
    end

  end
end
