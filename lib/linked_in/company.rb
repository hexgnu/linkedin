module LinkedIn
  class Company
    # include ROXML
    # xml_convention {|val| val.gsub("_","-") }
    # xml_reader :type
    # xml_reader :name
    # xml_reader :industry
    
    def initialize(doc)
      @doc = doc
    end
    
    %w[type name industry].each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./#{f.gsub(/_/,'-')}").text
      end
    end
    
  end
end