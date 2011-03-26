module LinkedIn
  class Job < LinkedIn::Base
    def id
      @doc.xpath("./job/id").text.to_i
    end
    
    def position
      Position.new(Nokogiri::XML(@doc.xpath('./job/position').to_xml)).positions.first
    end
    
    def company
      Company.new(Nokogiri::XML(@doc.xpath('./job/company').children.to_xml))
    end
    
    def poster
      Profile.new(Nokogiri::XML(@doc.xpath('./job/job-poster').to_xml.gsub(/job-poster/, "person")))
    end
    
    def site_job_request
      @doc.xpath("./job/site-job-request/url").text
    end
  end
end