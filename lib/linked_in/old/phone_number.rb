module LinkedIn
  class PhoneNumber < LinkedIn::Base

    def phone_numbers
      @array ||= begin
        @array = []
        @doc.children.each do |pn|
          @array << Resource.new(pn) unless pn.blank?
        end
        @array
      end
    end

    class Resource

      def initialize(phone_number)
        @phone_number = phone_number
      end

      %w[phone_type phone_number].each do |f|
        define_method(f.to_sym) do
          @phone_number.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end
      
    end # resource class

  end # phone_number class
end
