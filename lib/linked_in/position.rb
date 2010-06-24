module LinkedIn
  class Position
    # include ROXML
    # xml_convention {|val| val.gsub("_","-") }
    # xml_reader :id
    # xml_reader :title
    # xml_reader :summary
    # xml_reader :start_year, :from => "start-date/year", :as => Integer
    # xml_reader :start_month, :from => "start-date/month", :as => Integer
    # xml_reader :end_year, :from => "end-date/year", :as => Integer
    # xml_reader :end_month, :from => "end-date/month", :as => Integer
    # xml_reader :is_current
    # xml_reader :company, :as => Company
    def initialize(doc)
      @doc = doc
    end
    
    def positions
      @doc.children
      @arry ||= begin
        @arry = []
        @doc.children.each do |position|
          @arry << Resource.new(position) unless position.xpath('id').blank?
        end
        @arry
      end
    end
    
    class Resource
      # <position>
      #   <id>4891362</id>
      #   <title>Solution Architect</title>
      #   <summary>blob of text</summary>
      #   <start-date>
      #     <year>2004</year>
      #     <month>10</month>
      #   </start-date>
      #   <end-date>
      #     <year>2007</year>
      #     <month>6</month>
      #   </end-date>
      #   <is-current>false</is-current>
      #   <company>
      #     <name>Hewlett-Packard</name>
      #   </company>
      # </position>
      
      def initialize(position)
        @position = position
      end
      
      %w[id title summary].each do |f|
        define_method(f.to_sym) do
          @position.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end
      
      def start_month
        @position.xpath('./start-date/month').text.to_i
      end
      
      def start_year
        @position.xpath('./start-date/year').text.to_i
      end
      
      def end_month
        @position.xpath('./end-date/month').text.to_i
      end
      
      def end_year
        @position.xpath('./end-date/year').text.to_i
      end
      
      def company
        @company ||= Company.new(@position.xpath('./company'))
      end
      
    end
    
  end # class
end # module
