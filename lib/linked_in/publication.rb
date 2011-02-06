module LinkedIn
  class Publication < LinkedIn::Base

    def publications
      @array ||= begin
        @array = []
        @doc.children.each do |publication|
          @array << Resource.new(publication) unless publication.blank?
        end
        @array
      end
    end

    class Resource

      def initialize(publication)
        @publication = publication
      end
      
      %w[id title].each do |f|
        define_method(f.to_sym) do
          @publication.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end
      
      def year
        @year ||= @publication.xpath("./date/year").text.to_i
      end

      def day
        @day ||= @publication.xpath("./date/day").text.to_i
      end

      def month
        @month ||= @publication.xpath("./date/month").text.to_i
      end

      def date
        Date.civil(y=year,m=month,d=day)
      end
      
    end # resource class

  end # publication class
end
