require 'helper'

describe LinkedIn::Search do

	let(:client){LinkedIn::Client.new('token', 'secret')}

	it "should be able to mock search results" do
		LinkedIn.mocking = true
		s = client.search
		s.should be_an_instance_of(LinkedIn::Mash)
		s.people._count.should == 2
		s.people.all.count.should == 2
		s.people.all.first.should have_key('first_name')
		s.people.all.first.should have_key('last_name')		
	end

end
