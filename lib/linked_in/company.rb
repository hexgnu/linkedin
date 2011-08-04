module LinkedIn
  class Company < LinkedIn::Base

    %w[id type name size industry ticker].each do |f|
      define_method(f.to_sym) do
        @doc.xpath("./#{f.gsub(/_/,'-')}").text
      end
    end

  end
end
