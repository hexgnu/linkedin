module LinkedIn
  class UrlResource < LinkedIn::Base

    def resources
      @array ||= begin
        @array = []
        @doc.children.each do |url|
          @array << Resource.new(url) unless url.blank?
        end
        @array
      end
    end

    class Resource

      def initialize(member_url)
        @member_url = member_url
      end

      %w[url name].each do |f|
        define_method(f.to_sym) do
          @member_url.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end

    end # resource class

  end
end
