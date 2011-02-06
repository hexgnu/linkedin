module LinkedIn
  class Patents < LinkedIn::Base

    def patents
      @patents ||= @doc.children.inject([]) do |list, patent|
        list << Resource.new(patent) unless patent.blank?
        list
      end
    end

    class Resource

      def initialize(patent)
        @patent = patent
      end

      %w[id title].each do |f|
        define_method(f.to_sym) do
          @patent.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end

      def year
        @year ||= @patent.xpath("./date/year").text.to_i
      end

      def day
        @day ||= @patent.xpath("./date/day").text.to_i
      end

      def month
        @month ||= @patent.xpath("./date/month").text.to_i
      end

      def date
        Date.civil(y=year,m=month,d=day)
      end

    end # resource class

  end # patent class
end
