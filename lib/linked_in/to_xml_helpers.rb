module LinkedIn
  module ToXmlHelpers

    private

    def status_to_xml(status)
      doc = Nokogiri.XML('<current-status/>', nil, 'UTF-8')
      doc.root.content = status
      doc.to_xml
    end

    def message_to_xml(message)
      doc = Nokogiri.XML('')
      doc.encoding = 'UTF-8'
      doc.root = message.to_xml_node(doc)
      doc.to_xml
    end

    def share_to_xml(options={})
      doc = Nokogiri.XML('<share><comment/><content><title/><description/><submitted-url/><submitted-image-url/></content><visibility><code/></visibility></share>')
      doc.encoding = 'UTF-8'

      {:comment => 'comment', :title => 'title', :description => 'description', :url => 'submitted-url', :image_url => 'submitted-image-url'}.each do |key, name|
        doc.at_css(name).content = options[key] if options[key]
      end

      doc.at_css('visibility > code').content = options[:visibility] || options[:visability] # backward-compatible typo fix
      doc.to_xml
    end

    def comment_to_xml(comment)
      doc = Nokogiri.XML('<update-comment><comment/><update-comment/>')
      doc.encoding = 'UTF-8'
      doc.at_css('comment').content = comment
      doc.to_xml
    end

    def is_liked_to_xml(is_liked)
      doc = Nokogiri.XML('<is-liked/>')
      doc.encoding = 'UTF-8'
      doc.at_css('is-liked').content = is_liked
      doc.to_xml
    end

    def network_update_to_xml(message)
      doc = Nokogiri::XML('<activity locale="en_US"><content-type>linkedin-html</content-type><body/></activity>')
      doc.encoding = 'UTF-8'
      doc.at_css('body').content = message
      doc.to_xml
    end

  end
end
