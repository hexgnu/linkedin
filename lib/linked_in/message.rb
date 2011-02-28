module LinkedIn
  class Message

    attr_accessor :subject, :body, :recipients
  
    def to_xml
      self.to_xml_node(Nokogiri.XML('<root/>', nil, 'UTF-8')).to_xml
    end

    def to_xml_node(doc)
      node = Nokogiri::XML::DocumentFragment.new(doc, '<mailbox-item><recipients/><subject/><body/></mailbox-item>')
      node.at_css('recipients').add_child(self.recipients.to_xml_nodes(doc))
      node.at_css('subject').content = self.subject
      node.at_css('body').content = self.body
      node
    end

  end

end
