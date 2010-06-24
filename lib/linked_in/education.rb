module LinkedIn
  class Education
    def initialize(doc)
      @doc = doc
    end

    def education
      @arry ||= begin
        @arry = []
        @doc.children.each do |edu|
          @arry << Resource.new(edu) unless edu.xpath('id').blank?
        end
        @arry
      end
    end

    class Resource

      def initialize(education)
        @education = education
      end

      %w[id school_name degree field_of_study activities].each do |f|
        define_method(f.to_sym) do
          @education.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end

      def start_month
        @education.xpath('./start-date/month').text.to_i
      end

      def start_year
        @education.xpath('./start-date/year').text.to_i
      end

      def end_month
        @education.xpath('./end-date/month').text.to_i
      end

      def end_year
        @education.xpath('./end-date/year').text.to_i
      end
    end # resource class

  end # education class
end
