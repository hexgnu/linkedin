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
      p.last_name.should  == 'Netherland'
    end
    
    should "retrieve location information" do
      stub_get("/v1/people/~", "profile_full.xml")
      p = @linkedin.profile
      p.location.name.should    == 'Dallas/Fort Worth Area'
      p.location.country.should == 'us'
    end
    
    should "retrieve positions from a profile" do
      stub_get("/v1/people/~", "profile_full.xml")
      p = @linkedin.profile
      p.positions.size.should == 4
      p.positions.first.company.name.should == 'Orrka'
      p.positions.first.is_current.should   == 'true'
      
      hp = p.positions[2]
      hp.title.should       == 'Solution Architect'
      hp.id.should          == '4891362'
      hp.start_month.should == 10
      hp.start_year.should  == 2004
      hp.end_month.should   == 6
      hp.end_year.should    == 2007
      hp.is_current.should  == 'false'
    end

    should "retrieve education information from a profile" do
      stub_get("/v1/people/~", "profile_full.xml")
      p = @linkedin.profile
      education = p.education.first
      education.start_month.should == 8
      education.start_year.should  == 1994
      education.end_month.should   == 5
      education.end_year.should    == 1998
    end

    should "retrieve information about a profiles connections" do
      stub_get("/v1/people/~", "profile_full.xml")
      p = @linkedin.profile
      p.connections.size.should == 146
      p.connections.first.first_name.should == "Ali"
    end
    
    should "retrieve a profiles member_url_resources" do
      stub_get("/v1/people/~", "profile_full.xml")
      p = @linkedin.profile
      p.member_url_resources.size.should == 2
      p.member_url_resources.first.url.should  == 'http://orrka.com'
      p.member_url_resources.first.name.should == 'My Company'
    end
    
    should "retrieve a profiles connections api_standard_profile_request" do
      stub_get("/v1/people/~", "profile_full.xml")
      p = @linkedin.profile
      p1 = p.connections.first
      p1.api_standard_profile_request.url.should == 'http://api.linkedin.com/v1/people/3YNlBdusZ5:full'
      p1.api_standard_profile_request.headers[:name].should  == 'x-li-auth-token'
      p1.api_standard_profile_request.headers[:value].should == 'name:lui9'
    end

    should "retrieve a profile for a member by id" do
      stub_get("/v1/people/id=gNma67_AdI", "profile.xml")
      p = @linkedin.profile(:id => "gNma67_AdI")
      p.first_name.should == 'Wynn'
    end

    should "retrieve a site_standard_profile_request" do
      stub_get("/v1/people/~", "profile.xml")
      p = @linkedin.profile
      p.site_standard_profile_request.should == "http://www.linkedin.com/profile?viewProfile=&key=3559698&authToken=yib-&authType=name"
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
      results.start.should == 0
      results.count.should == 10
      results.profiles.first.first_name.should == 'Zach'
      results.profiles.first.last_name.should  == 'Inglis'
    end

    should "perform a search by multiple keywords" do
      stub_get("/v1/people?keywords=ruby+rails", "search.xml")
      results = @linkedin.search(:keywords => ["ruby", "rails"])
      results.start.should == 0
      results.count.should == 10
      results.profiles.first.first_name.should == 'Zach'
      results.profiles.first.last_name.should  == 'Inglis'
    end

    should "perform a search by name" do
      stub_get("/v1/people?name=Zach+Inglis", "search.xml")
      results = @linkedin.search(:name => "Zach Inglis")
      results.start.should == 0
      results.count.should == 10
      results.profiles.first.first_name.should == 'Zach'
      results.profiles.first.last_name.should  == 'Inglis'
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
      stats.updates.first.timestamp.should == 1259179809524
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

    should "send a message to recipients" do
      stub_post("/v1/people/~/mailbox", "mailbox_items.xml")
      recipients = ["/people/~", "/people/abcdefg"]
      subject    = "Congratulations on your new position."
      body       = "You're certainly the best person for the job!"

      @linkedin.send_message(subject, body, recipients).should == "200"
    end

  end
end
