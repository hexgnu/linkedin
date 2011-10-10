require 'helper'

describe LinkedIn::Client::Company do

  before do
    @client = LinkedIn::Client.new
  end

  describe ".company" do
    it "should return the company of the id" do
      stub_get("/companies/660862").
        to_return(:body => fixture("company.json"))
      company = @client.company(660862)
      company.name == "Code for America"
    end
  end
end
