require 'test_helper'

class SearchParamTest < Test::Unit::TestCase
  context "Setting search parameters" do
    should "add a facet when add_facet is called" do
      s = SearchParams.new
      s.add_facet(:network, "F")
      s.facets[:network].should == ["F"]
    end

    should "add multiple facets when add_facet is called twice" do
      s = SearchParams.new
      s.add_facet(:network, "F")
      s.add_facet(:network, "S")

      s.facets[:network].should == ["F","S"]
    end

    should "not allow direct set of facets" do
      s = SearchParams.new
      s.should_not respond_to :facets=
    end

    should "not allow direct set of company, title, or school" do
      s = SearchParams.new
      s.should_not respond_to :company=
      s.should_not respond_to :title=
      s.should_not respond_to :school=
    end
  end
end
