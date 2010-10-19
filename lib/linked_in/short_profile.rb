class ShortProfileGroup < LinkedIn::Base
  def profiles
    @array ||= begin
      @array = []
      @doc.children.each do |reco|
        @array << ShortProfile.new(reco) unless reco.blank?
      end
      @array
    end
  end
end

class ShortProfile < LinkedIn::Base
  %w[first_name last_name id].each do |f|
    define_method(f.to_sym) do
      @doc.xpath("./#{f.gsub(/_/,'-')}").text
    end
  end
end
