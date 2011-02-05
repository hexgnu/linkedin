module LinkedIn

  class ShortProfile < LinkedIn::Base

    %w[id first_name last_name].each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./#{f.gsub(/_/,'-')}").text
      end
    end

  end

end
