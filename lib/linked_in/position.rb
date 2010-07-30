module LinkedIn
  class Position < LinkedIn::Base

    def positions
      @arry ||= begin
        @arry = []
        @doc.children.each do |position|
          @arry << Resource.new(position) unless position.blank?
        end
        @arry
      end
    end

    class Resource

      def initialize(position)
        @position = position
      end

      %w[id title summary is_current].each do |f|
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

    end # resource

  end # class
end # module
