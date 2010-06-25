module LinkedIn
  class Connections
    # include ROXML
    # xml_convention {|val| val.gsub("_","-") }
    # xml_reader :profiles, :as => [Profile], :from => 'person'
    
    # def self.from_xml(doc)
    #   new(Nokogiri::XML(doc))
    # end
    
    def initialize(doc)
      @doc = doc
    end
    
    def connections
      # puts @doc.children
      @arry ||= begin
        connections = @doc.xpath('//connections')
        @arry = []
        connections.children.each do |profile|
          @arry << Profile.new(Nokogiri::XML(profile.to_xml)) unless profile.blank?
        end
        @arry
      end
    end
    
  end
end