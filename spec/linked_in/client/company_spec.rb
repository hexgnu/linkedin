require 'helper'

describe LinkedIn::Client::Company do

  before do
    @client = LinkedIn::Client.new
  end

  describe ".company" do
    it "should return the company of the id" do
      stub_get("/companies/660862").
        to_return(:body => fixture("company.json"))
      company = @client.company(:id => 660862)
      company.name.should == "Code for America"
    end

    it "should return the company when searching by universal name" do
      stub_get("/companies/universal-name=linkedin").
        to_return(:body => fixture("company_linked_in.json"))
      company = @client.company(:universal_name => "linkedin")
      company.name.should == "LinkedIn"
    end

    it "should return the company filtered by email domain" do
      stub_get("/companies?email-domain=apple.com").
        to_return(:body => fixture("company_apple.json"))
      company = @client.company(:email_domain => "apple.com")
      company._total.should == 2
    end

  end
end
