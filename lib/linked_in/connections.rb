module LinkedIn
  class Connections

    def self.from_xml(doc)
      new(Nokogiri::XML(doc))
    end

    def initialize(doc)
      @doc = doc
    end

    def connections
      @array ||= begin
        @array = []
        @doc.xpath('//connections').children.each do |profile|
          @array << Profile.new(Nokogiri::XML(profile.to_xml)) unless profile.blank?
        end
        @array
      end
    end

    def profiles
      connections
    end

  end
end
