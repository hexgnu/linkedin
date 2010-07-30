module LinkedIn
  class Error < LinkedIn::Base

    def status
      @doc.xpath('//status').text.to_i
    end

    def timestamp
      @doc.xpath('//timestamp').text.to_i
    end

    def code
      @doc.xpath('//error-coce').text.to_i
    end

    def message
      @doc.xpath('//message').text
    end

  end
end
