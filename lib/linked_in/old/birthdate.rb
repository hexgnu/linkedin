module LinkedIn
  class Birthdate < LinkedIn::Base

    def year
      @year ||= @doc.xpath("/person/date-of-birth/year").text.to_i
    end

    def day
      @day ||= @doc.xpath("/person/date-of-birth/day").text.to_i
    end

    def month
      @month ||= @doc.xpath("/person/date-of-birth/month").text.to_i
    end

    def to_date
      Date.civil(y=year,m=month,d=day)
    end

  end
end
