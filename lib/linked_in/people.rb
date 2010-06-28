module LinkedIn
  class People

    # xml_reader :profiles, :as => [Profile], :from => 'person'
    
    def self.from_xml(doc)
      new(Nokogiri::XML(doc))
    end

    def initialize(doc)
      @doc = doc
    end
  
    FIELDS = %w[total start count]

    FIELDS.each do |f|
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