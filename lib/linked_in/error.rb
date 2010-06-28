module LinkedIn
  class Error

    # <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    # <error>
    #   <status>404</status>
    #   <timestamp>1259166999063</timestamp>
    #   <error-code>0000</error-code>
    #   <message>Could not find person based on: ~~</message>
    # </error>

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
