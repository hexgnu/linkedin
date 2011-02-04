module LinkedIn
  class Message

    attr_accessor :subject, :body, :recipients

    def to_xml
      "<mailbox-item>
        <recipients>
          #{recipients.to_xml}
        </recipients>
        <subject>#{subject}</subject>
        <body>#{body}</body>
      </mailbox-item>"
    end

  end

end
