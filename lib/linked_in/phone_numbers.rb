module LinkedIn
  class PhoneNumbers < LinkedIn::Base

    def numbers
      @arry ||= begin
        @arry = []
        @doc.children.each do |phone_number|
          @arry << PhoneNumber.new(phone_number) unless phone_number.blank?
        end
        @arry
      end
    end

    class PhoneNumber

      def initialize(phone_number)
        @phone_number = phone_number
      end

      def type
        @phone_number.xpath("./phone-type").text
      end

      def number
        @phone_number.xpath("./phone-number").text
      end

    end

  end
end
