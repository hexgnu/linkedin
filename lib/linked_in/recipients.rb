module LinkedIn
  class Recipients
    
    attr_accessor :recipients
    
    def to_xml
      str = ''
      recipients.each do |recipient|
        str << "<recipient><person path=#{recipient.person.path}/></recipient>"
      end
      str
    end
  end
end
