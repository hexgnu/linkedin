require 'helper'

describe LinkedIn::Api do
  before do
    client.stub(:consumer).and_return(consumer)
    client.authorize_from_access('atoken', 'asecret')
  end

  let(:client){LinkedIn::Client.new('token', 'secret')}
  let(:consumer){OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})}

  it "should be able to view the account profile" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}")
    client.profile.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view public profiles" do
    stub_request(:get, "https://api.linkedin.com/v1/people/id=123").to_return(:body => "{}")
    client.profile(:id => 123).should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view connections" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/connections").to_return(:body => "{}")
    client.connections.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_updates" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates").to_return(:body => "{}")
    client.network_updates.should be_an_instance_of(LinkedIn::Mash)
  end
  
  it "should be able to search with a keyword if given a String" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search?keywords=business").to_return(:body => "{}")
    client.search("business").should be_an_instance_of(LinkedIn::Mash)
  end
  
  it "should be able to search with an option" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search?first-name=Javan").to_return(:body => "{}")
    client.search(:first_name => "Javan").should be_an_instance_of(LinkedIn::Mash)
  end
  
  it "should be able to search with an option and fetch specific fields" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search:(num-results,total)?first-name=Javan").to_return(:body => "{}")
    client.search(:first_name => "Javan", :fields => ["num_results", "total"]).should be_an_instance_of(LinkedIn::Mash)
  end

  context "Company API" do
    use_vcr_cassette

    it "should be able to view a company profile" do 
      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586").to_return(:body => "{}")
      client.company(:id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should load correct company data" do
      client.company(:id => 1586).name.should == "Amazon"

      data = client.company(:id => 1586, :fields => %w{ id name industry locations:(address:(city state country-code) is-headquarters) employee-count-range })
      data.id.should == 1586
      data.name.should == "Amazon"
      data.employee_count_range.name.should == "10001+"
      data.industry.should == "Internet"
      data.locations.all[0].address.city.should == "Seattle"
      data.locations.all[0].is_headquarters.should == true
    end
  end

end
