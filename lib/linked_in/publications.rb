module LinkedIn
  class Publications < LinkedIn::Base

    def publications
      @publications ||= @doc.children.inject([]) do |list, publication|
        list << Resource.new(publication) unless publication.blank?
        list
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
        Date.civil(year, month, day)
      end
    end

  end
end
