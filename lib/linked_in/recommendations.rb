module LinkedIn

  class Recommendations < LinkedIn::Base

    def recommendations
      @recommendations ||= @doc.children.inject([]) do |list, recommendation|
        list << Recommendation.new(recommendation) unless recommendation.blank?
        list
      end
    end

    class Recommendation
      def initialize(recommendation)
        @recommendation = recommendation
      end

      %w[id recommendation_type recommendation_text].each do |f|
        define_method(f.to_sym) do
          @recommendation.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end

      def recommender
        @recommender ||= ShortProfile.new(@recommendation.xpath('./recommender'))
      end
    end

  end

end
