module LinkedIn
  class Languages < LinkedIn::Base

    def languages
      @languages ||= @doc.children.inject([]) do |list, lang|
        list << Resource.new(lang) unless lang.blank?
        list
      end
    end

    class Resource
      # proficiency level not implemented yet
      # http://developer.linkedin.com/community/apis/blog/2011/01/04/new-profile-fields-are-here
      def initialize(language)
        @language = language
      end

      def id
        @language.xpath("./id").text
      end

      def name
        @language.xpath("./language/name").text
      end
    end

  end
end
