require 'helper'

class MyMocker < LinkedIn::Mocker
end

describe LinkedIn::Mocker do

	before do
		LinkedIn.debug = true
		LinkedIn.mocking = true
	end

	let(:client){LinkedIn::Client.new('token', 'secret')}

	it "should be able to mock search results" do
		s = client.search
		s.should be_an_instance_of(LinkedIn::Mash)
		s.people._count.should == 2
		s.people.all.count.should == 2
		s.people.all.first.should have_key('first_name')
		s.people.all.first.should have_key('last_name')		
	end

	it "should be able to mock the account profile" do
		profile = client.profile
		profile.should be_an_instance_of(LinkedIn::Mash)
		profile.first_name.should == "My First Name"
		profile.last_name.should == "My Last Name"
	end

	it "should be able to mock the account connections" do
		c = client.connections
		c.should be_an_instance_of(LinkedIn::Mash)
	end

	it "should be able to mock another profile" do
		[client.profile(:id => 123), client.profile(:url => "http://www.google.com")].each do |profile|
			profile.should be_an_instance_of(LinkedIn::Mash)
			profile.first_name.should_not == "My First Name"
			profile.last_name.should_not == "My Last Name"
		end
	end

	it "should be able to mock network updates" do
		n = client.network_updates
		n.should be_an_instance_of(LinkedIn::Mash)
		n.numResults.should == 42
	end

end
