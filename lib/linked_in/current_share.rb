module LinkedIn

  class CurrentShare < LinkedIn::Base
    %w[id comment].each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./#{f.gsub(/_/,'-')}").text
      end
    end

    def submitted_url
      @doc.xpath('./content/submitted-url').text
    end

    def resolved_url
      @doc.xpath('./content/resolved-url').text
    end

    def shortened_url
      @doc.xpath('./content/shortened-url').text
    end

    def title
      @doc.xpath('./content/title').text
    end

    def description
      @doc.xpath('./content/description').text
    end

    def submitted_image_url
      @doc.xpath('./content/submitted-image-url').text
    end

    def thumbnail_url
      @doc.xpath('./content/thumbnail-url').text
    end

    def timestamp
      time = @doc.xpath('./timestamp').text.to_i
      Time.at(time / 1000)
    end

    def visibility
      @doc.xpath('./visibility/code').text
    end

    def application
      @doc.xpath('./source/application/name').text
    end

    def author
      @author ||= ShortProfile.new(@doc.xpath('./author'))
    end
  end

end
