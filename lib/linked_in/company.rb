module LinkedIn
  class Company < LinkedIn::Base

    %w[type name industry].each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./#{f.gsub(/_/,'-')}").text
      end
    end

  end
end
