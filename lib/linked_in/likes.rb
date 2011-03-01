module LinkedIn
  class Likes < LinkedIn::Base

    def likes
      @likes ||= @doc.xpath('//likes').children.inject([]) do |list, like|
        list << Resource.new(like) unless like.blank?
        list
      end
    end

    class Resource
      def initialize(like)
        @like = like
      end

      def profile
        Profile.new(Nokogiri::XML(@like.xpath('./person').to_xml))
      end

    end

  end
end
