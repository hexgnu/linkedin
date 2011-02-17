module LinkedIn
  class Recipients

    attr_accessor :recipients

    def to_xml
      self.to_xml_nodes(Nokogiri.XML('<root/>', nil, 'UTF-8')).to_xml
    end
    
    def to_xml_nodes(doc)
      recipients.inject(Nokogiri::XML::NodeSet.new(doc)) do |nodes, recipient|
        node = Nokogiri::XML::DocumentFragment.new(doc, '<recipient><person/></recipient>')
        node.at_css('person')['path'] = recipient.person.path
        nodes << node
      end
    end
  end
end
