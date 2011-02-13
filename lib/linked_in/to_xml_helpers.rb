module LinkedIn
  module ToXmlHelpers

    XML_HEADER = %Q{<?xml version="1.0" encoding="UTF-8"?>}

    private

    def status_to_xml(status)
      %Q{#{XML_HEADER}\n<current-status>#{status}</current-status>}
    end

    def message_to_xml(message)
      %Q{#{XML_HEADER}\n#{message.to_xml}}
    end

    def share_to_xml(options={})
%Q{#{XML_HEADER}
<share>
  <comment>#{options[:comment] if options[:comment]}</comment>
  <content>
    <title>#{options[:title] if options[:title]}</title>
    <submitted-url>#{options[:url] if options[:url]}</submitted-url>
    <submitted-image-url>#{options[:image_url] if options[:image_url]}</submitted-image-url>
  </content>
  <visibility>
    <code>#{options[:visability]}</code>
  </visibility>
</share>}
    end

    def comment_to_xml(comment)
%Q{#{XML_HEADER}
<update-comment>
  <comment>#{comment}</comment>
</update-comment>}
    end

    def is_liked_to_xml(is_liked)
%Q{#{XML_HEADER}
<is-liked>#{is_liked}</is-liked>}
    end

    def network_update_to_xml(message)
%Q{#{XML_HEADER}
<activity locale="en_US">
  <content-type>linkedin-html</content-type>
  <body>#{message}</body>
</activity>}
    end

  end
end