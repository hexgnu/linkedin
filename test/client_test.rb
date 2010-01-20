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
      
      hp = p.positions[2]
      hp.start_month.should == 10
      hp.start_year.should == 2004
      hp.end_month.should == 6
      hp.end_year.should == 2007
      
      education = p.education.first
      education.start_month.should == 8
      education.start_year.should == 1994
      education.end_month.should == 5
      education.end_year.should == 1998
      
      p.connections.size.should == 146
      p.connections.first.first_name.should == "Ali"
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
    
    should "perform a search by keyword" do
      stub_get("/v1/people?keywords=github", "search.xml")
      results = @linkedin.search(:keywords => 'github')
      results.start == 0
      results.count == 10
      results.profiles.first.first_name.should == 'Zach'
      results.profiles.first.last_name.should == 'Inglis'
    end
    
    should "perform a search by multiple keywords" do
      stub_get("/v1/people?keywords=ruby+rails", "search.xml")
      results = @linkedin.search(:keywords => ["ruby", "rails"])
      results.start == 0
      results.count == 10
      results.profiles.first.first_name.should == 'Zach'
      results.profiles.first.last_name.should == 'Inglis'
    end
    
    should "perform a search by name" do
      stub_get("/v1/people?name=Zach+Inglis", "search.xml")
      results = @linkedin.search(:name => "Zach Inglis")
      results.start == 0
      results.count == 10
      results.profiles.first.first_name.should == 'Zach'
      results.profiles.first.last_name.should == 'Inglis'
    end
    
    should "update a user's current status" do
      stub_put("/v1/people/~/current-status", "blank.xml")
      @linkedin.update_status("Testing out the LinkedIn API")
    end
    
    should "clear a user's current status" do
      stub_delete("/v1/people/~/current-status", "blank.xml")
      @linkedin.clear_status
    end
    
    should "retrieve the authenticated user's current status" do
      stub_get("/v1/people/~/current-status", "status.xml")
      @linkedin.current_status.should == "New blog post: What makes a good API wrapper? http://wynnnetherland.com/2009/11/what-makes-a-good-api-wrapper/"
    end
    
    should "retrieve status updates for the authenticated user's network" do
      stub_get("/v1/people/~/network?type=STAT", "network_statuses.xml")
      stats = @linkedin.network_statuses
      stats.updates.first.profile.id.should == "19408512"
      stats.updates.first.profile.first_name.should == 'Vahid'
      stats.updates.first.profile.connections.first.id.should == "28072758"
      stats.updates.first.profile.connections.first.last_name.should == 'Varone'
      
    end
    
    should "retrieve network updates" do
      stub_get("/v1/people/~/network?type=PICT", "picture_updates.xml")
      stats = @linkedin.network_updates(:type => "PICT")
      stats.updates.size.should == 4
      stats.updates.last.profile.headline.should == "Creative Director for Intridea"
    end

  end
  
end