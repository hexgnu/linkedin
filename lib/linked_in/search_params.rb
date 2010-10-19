class SearchParams
  def initialize
    
    @title = CurrentOrPastItem.new
    @company = CurrentOrPastItem.new
    @school = CurrentOrPastItem.new
    @facets = {}
  end

  # Simple search fields
  attr_accessor :keywords, :first_name, :last_name, :country_code,
    :postal_code, :distance

  attr_reader :title, :company, :school, :facets

  def add_facet (field, value)
    if @facets[field]
      @facets[field].push(value)
    else
      @facets[field] = [value]
    end
  end

end

class CurrentOrPastItem
  def initialize
    @allow_current = false
  end

  attr_accessor :search_value, :allow_current
end

