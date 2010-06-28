module LinkedIn
  class Company
    
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