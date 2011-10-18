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

    it "should return the company with company fields passed" do
      stub_get("/companies/660862:(id,name,ticker,description)").
        to_return(:body => fixture("company.json"))
      company = @client.company(:id => "660862",:fields => ['id','name','ticker','description'])
      company.description.should == "Code For America seeks to connect talented developers within the tech industry to work directly with cities around the country to create and deploy open source solutions to make civic services more effective, efficient, and open."
    end


  end
end
