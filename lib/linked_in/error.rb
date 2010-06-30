module LinkedIn
  class Error

    def initialize(doc)
      @doc = doc
    end

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
