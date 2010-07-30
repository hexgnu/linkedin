module LinkedIn
  class Message
    include ROXML
    xml_name "mailbox-item"
    xml_convention { |val| val.gsub("_", "-") }
    xml_accessor :recipients, :as => Recipients, :from => "recipients"
    xml_accessor :subject
    xml_accessor :body
  end
end
