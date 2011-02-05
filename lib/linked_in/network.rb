module LinkedIn
  class Network < LinkedIn::Base

    def updates
      @updates ||= @doc.xpath('//updates').children.inject([]) do |list, update|
        list << Update.new(Nokogiri::XML(update.to_xml)) unless update.blank?
        list
      end
    end

  end
end
