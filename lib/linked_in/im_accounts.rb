module LinkedIn
  class ImAccounts < LinkedIn::Base
    def im_accounts
      @array ||= begin
        @array = []
        @doc.children.each do |pn|
          @array << Resource.new(pn) unless pn.blank?
        end
        @array
      end
    end

    class Resource

      def initialize(im_account)
        @im_account = im_account
      end

      # To match the API signature
      %w[im_account_type im_account_name].each do |f|
        define_method(f.to_sym) do
          @im_account.xpath("./#{f.gsub(/_/,'-')}").text
        end
      end
      
    end # resource class
    
  end
end