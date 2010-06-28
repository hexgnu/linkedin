module LinkedIn
  class Connections

    def self.from_xml(doc)
      new(Nokogiri::XML(doc))
    end

    def initialize(doc)
      @doc = doc
    end

    def connections
      @arry ||= begin
        connections = @doc.xpath('//connections')
        @arry = []
        connections.children.each do |profile|
          @arry << Profile.new(Nokogiri::XML(profile.to_xml)) unless profile.blank?
        end
        @arry
      end
    end
    
    def profiles
      connections
    end
    
  end
end
