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

	it "should be able to mock the account profile" do
		LinkedIn.mocking = true

    profile = client.profile
    profile.should be_an_instance_of(LinkedIn::Mash)
    profile.first_name.should == "My First Name"
    profile.last_name.should == "My Last Name"

		LinkedIn.mocking = false
	end

	it "should be able to mock another profile" do
		LinkedIn.mocking = true

    [client.profile(:id => 123), client.profile(:url => "http://www.google.com")].each do |profile|
		  profile.should be_an_instance_of(LinkedIn::Mash)
		  profile.first_name.should_not == "My First Name"
		  profile.last_name.should_not == "My Last Name"
		end

		LinkedIn.mocking = false
	end

end
