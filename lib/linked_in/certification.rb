module LinkedIn
  class Certification < LinkedIn::Base

    def certifications
      @certifications ||= @doc.children.inject([]) do |list, cert|
        list << Resource.new(cert) unless cert.blank?
        list
      end
    end

    class Resource
      def initialize(certification)
        @certification = certification
      end

      %w[id name].each do |f|
        define_method(f.to_sym) do
          @certification.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end
    end
  end
end

