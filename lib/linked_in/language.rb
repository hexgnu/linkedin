module LinkedIn
  class Language < LinkedIn::Base

    def languages
      @array ||= begin
        @array = []
        @doc.children.each do |lang|
          @array << Resource.new(lang) unless lang.blank?
        end
        @array
      end
    end

    class Resource

      def initialize(language)
        @language = language
      end

      def name
        @language.xpath("./language/name").text
      end
      
      %w[id].each do |f| #proficiency level to come? http://developer.linkedin.com/community/apis/blog/2011/01/04/new-profile-fields-are-here
        define_method(f.to_sym) do
          @language.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end
      
    end # resource class

  end # language class
end
