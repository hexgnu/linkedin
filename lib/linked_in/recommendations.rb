module LinkedIn
  class Recommendations < LinkedIn::Base
    def recommendations
      @array ||= begin
        @array = []
        @doc.children.each do |recommendation|
          @array << Recommendation.new(recommendation) unless recommendation.blank?
        end
        @array
      end
    end
  end
end
