module LinkedIn
  class Network
    
    def self.from_xml(doc)
      new(Nokogiri::XML(doc))
    end
    
    def initialize(doc)
      @doc = doc
    end
    
    def updates
      @array ||= begin
        @array = []
        @doc.xpath('//updates').children.each do |update|
          @array << Update.new(Nokogiri::XML(update.to_xml)) unless update.blank?
        end
        @array
      end
    end
    
  end
end