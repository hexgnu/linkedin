require 'test_helper'

class ClientTest < Test::Unit::TestCase
  context "when hitting the LinkedIn API" do
    setup do
      @linkedin = LinkedIn::Client.new('token', 'secret')
      consumer = OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})
      @linkedin.stubs(:consumer).returns(consumer)

      @linkedin.authorize_from_access('atoken', 'asecret')
    end

    should "retrieve a profile for the authenticated user" do
      stub_get("/v1/people/~", "profile_full.xml")
      p = @linkedin.profile
      p.first_name.should == 'Wynn'
      p.last_name.should == 'Netherland'
      p.positions.size.should == 4
      p.positions.first.company.name.should == 'Orrka'
    end
    
    should "retrieve a profile for a member by id" do
      stub_get("/v1/people/id=gNma67_AdI", "profile.xml")
      p = @linkedin.profile(:id => "gNma67_AdI")
      p.first_name.should == 'Wynn'
    end
    
    should "retrieve a profile for a member by url" do
      stub_get("/v1/people/url=http%3A%2F%2Fwww.linkedin.com%2Fin%2Fnetherland", "profile.xml")
      p = @linkedin.profile(:url => "http://www.linkedin.com/in/netherland")
      p.last_name.should == 'Netherland'
    end
    
    should "accept field selectors when retrieving a profile" do
      stub_get("/v1/people/~:(first-name,last-name)", "profile.xml")
      p = @linkedin.profile(:fields => [:first_name, :last_name])
      p.first_name.should == 'Wynn'
      p.last_name.should == 'Netherland'
    end
    
    should "retrieve connections for the authenticated user" do
      stub_get("/v1/people/~/connections", "connections.xml")
      cons = @linkedin.connections
      cons.size.should == 146
      cons.last.last_name.should == 'Yuchnewicz'
    end

  end
  
end