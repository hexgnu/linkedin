module LinkedIn
  class Recommendation < LinkedIn::Base
    
    def recommendations
      @array ||= begin
        @array = []
        @doc.children.each do |reco|
          @array << Resource.new(reco) unless reco.blank?
        end
        @array
      end
    end

    class Resource
      
      def initialize(recommendation)
        @recommendation = recommendation
      end

      %w[recommendation_type recommendation_text].each do |f|
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
