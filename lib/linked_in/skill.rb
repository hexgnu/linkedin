module LinkedIn
  class Skill < LinkedIn::Base

    def skills
      @array ||= begin
        @array = []
        @doc.children.each do |skill|
          @array << Resource.new(skill) unless skill.blank?
        end
        @array
      end
    end

    class Resource

      def initialize(skill)
        @skill = skill
      end

      def name
        @skill.xpath("./skill/name").text
      end
      
      %w[id].each do |f| #proficiency level to come? http://developer.linkedin.com/community/apis/blog/2011/01/04/new-profile-fields-are-here
        define_method(f.to_sym) do
          @skill.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end
      
    end # resource class

  end # skill class
end
