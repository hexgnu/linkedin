module LinkedIn
  class Network < LinkedIn::Base

    def updates
      @array ||= begin
        @array = []
        @doc.xpath('//updates').children.each do |update|
          @array << Update.new(Nokogiri::XML(update.to_xml)) unless update.blank?
        end
        @array
      end
    end

  end
end
