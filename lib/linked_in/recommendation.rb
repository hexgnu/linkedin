module LinkedIn
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
      @recommender ||= Profile.new(@recommendation.xpath('./recommender'))
    end

  end
end
