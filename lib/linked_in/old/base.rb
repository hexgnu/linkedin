module LinkedIn
  class Base

    def self.from_xml(doc)
      new(doc)
    end

    def initialize(doc)
      @doc = doc
    end

  end
end
