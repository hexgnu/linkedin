module LinkedIn
  class UrlResource < LinkedIn::Base

    def resources
      @resources ||= @doc.children.inject([]) do |list, url|
        list << Resource.new(url) unless url.blank?
        list
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
