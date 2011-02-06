module LinkedIn
  class Recipients

    attr_accessor :recipients

    def to_xml
      recipients.inject('') do |result, recipient|
        result << %Q{<recipient><person path="#{recipient.person.path}"/></recipient>}
        result
      end
    end
  end
end
