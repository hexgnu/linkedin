require 'helper'

describe LinkedIn::Client do

  # context "when hitting the LinkedIn API" do
  #
  #   before(:each) do
  #     LinkedIn.token = nil
  #     LinkedIn.secret = nil
  #     LinkedIn.default_profile_fields = nil
  #   end
  #
  #   let(:client) do
  #     client = LinkedIn::Client.new('token', 'secret')
  #     consumer = OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})
  #     client.stub(:consumer).and_return(consumer)
  #     client.authorize_from_access('atoken', 'asecret')
  #     client
  #   end
  #
  #   it "should retrieve a profile for the authenticated user" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #     client.profile.first_name.should == 'Wynn'
  #     client.profile.last_name.should  == 'Netherland'
  #   end
  #
  #   it "should retrieve location information" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #     client.profile.location.name.should    == 'Dallas/Fort Worth Area'
  #     client.profile.location.country.should == 'us'
  #   end
  #
  #   it "should retrieve positions from a profile" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     client.profile.positions.size.should == 4
  #     client.profile.positions.first.company.name.should == 'Orrka'
  #     client.profile.positions.first.is_current.should   == 'true'
  #
  #     hp = client.profile.positions[2]
  #     hp.title.should       == 'Solution Architect'
  #     hp.id.should          == '4891362'
  #     hp.start_month.should == 10
  #     hp.start_year.should  == 2004
  #     hp.end_month.should   == 6
  #     hp.end_year.should    == 2007
  #     hp.is_current.should  == 'false'
  #   end
  #
  #   it "should retrieve education information from a profile" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     education = client.profile.educations.first
  #     education.start_month.should == 8
  #     education.start_year.should  == 1994
  #     education.end_month.should   == 5
  #     education.end_year.should    == 1998
  #   end
  #
  #   it "should retrieve information about a profiles connections" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     client.profile.connections.size.should == 146
  #     client.profile.connections.first.first_name.should == "Ali"
  #   end
  #
  #   it "should retrieve a profiles member_url_resources" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     client.profile.member_url_resources.size.should == 2
  #     client.profile.member_url_resources.first.url.should  == 'http://orrka.com'
  #     client.profile.member_url_resources.first.name.should == 'My Company'
  #   end
  #
  #   it "should retrieve a profiles connections api_standard_profile_request" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     p1 = client.profile.connections.first
  #     p1.api_standard_profile_request.url.should == 'http://api.linkedin.com/v1/people/3YNlBdusZ5:full'
  #     p1.api_standard_profile_request.headers[:name].should  == 'x-li-auth-token'
  #     p1.api_standard_profile_request.headers[:value].should == 'name:lui9'
  #   end
  #
  #   it "should retrieve a profile for a member by id" do
  #     stub_get("/v1/people/id=gNma67_AdI", "profile.xml")
  #
  #     profile = client.profile(:id => "gNma67_AdI")
  #     profile.first_name.should == 'Wynn'
  #   end
  #
  #   it "should retrieve a site_standard_profile_request" do
  #     stub_get("/v1/people/~", "profile.xml")
  #
  #     client.profile.site_standard_profile_request.should == "http://www.linkedin.com/profile?viewProfile=&key=3559698&authToken=yib-&authType=name"
  #   end
  #
  #   it "should retrieve a profile for a member by url" do
  #     stub_get("/v1/people/url=http%3A%2F%2Fwww.linkedin.com%2Fin%2Fnetherland", "profile.xml")
  #
  #     profile = client.profile(:url => "http://www.linkedin.com/in/netherland")
  #     profile.last_name.should == 'Netherland'
  #   end
  #
  #   it "should accept field selectors when retrieving a profile" do
  #     stub_get("/v1/people/~:(first-name,last-name)", "profile.xml")
  #
  #     profile = client.profile(:fields => [:first_name, :last_name])
  #     profile.first_name.should == 'Wynn'
  #     profile.last_name.should == 'Netherland'
  #   end
  #
  #   it "should retrieve connections for the authenticated user" do
  #     stub_get("/v1/people/~/connections", "connections.xml")
  #
  #     cons = client.connections
  #     cons.size.should == 146
  #     cons.last.last_name.should == 'Yuchnewicz'
  #   end
  #
  #   it "should perform a search by keyword" do
  #     stub_get("/v1/people?keywords=github", "search.xml")
  #
  #     results = client.search(:keywords => 'github')
  #     results.start.should == 0
  #     results.count.should == 10
  #     results.profiles.first.first_name.should == 'Zach'
  #     results.profiles.first.last_name.should  == 'Inglis'
  #   end
  #
  #   it "should perform a search by multiple keywords" do
  #     stub_get("/v1/people?keywords=ruby+rails", "search.xml")
  #
  #     results = client.search(:keywords => ["ruby", "rails"])
  #     results.start.should == 0
  #     results.count.should == 10
  #     results.profiles.first.first_name.should == 'Zach'
  #     results.profiles.first.last_name.should  == 'Inglis'
  #   end
  #
  #   it "should perform a search by name" do
  #     stub_get("/v1/people?name=Zach+Inglis", "search.xml")
  #
  #     results = client.search(:name => "Zach Inglis")
  #     results.start.should == 0
  #     results.count.should == 10
  #     results.profiles.first.first_name.should == 'Zach'
  #     results.profiles.first.last_name.should  == 'Inglis'
  #   end
  #
  #   it "should update a user's current status" do
  #     stub_put("/v1/people/~/current-status", "blank.xml")
  #
  #     client.update_status("Testing out the LinkedIn API").code.should == "200"
  #   end
  #
  #   it "should post to a user's network stream" do
  #     stub_post("/v1/people/~/person-activities", "blank.xml")
  #
  #     client.update_network("Testing out the LinkedIn API").code.should == "201"
  #   end
  #
  #   it "should clear a user's current status" do
  #     stub_delete("/v1/people/~/current-status", "blank.xml")
  #
  #     client.clear_status.should == "200"
  #   end
  #
  #   it "should retrieve the authenticated user's current status" do
  #     stub_get("/v1/people/~/current-status", "status.xml")
  #
  #     client.current_status.should == "New blog post: What makes a good API wrapper? http://wynnnetherland.com/2009/11/what-makes-a-good-api-wrapper/"
  #   end
  #
  #   it "should retrieve status updates for the authenticated user's network" do
  #     stub_get("/v1/people/~/network?type=STAT", "network_statuses.xml")
  #
  #     stats = client.network_statuses
  #     stats.updates.first.timestamp.should == 1259179809524
  #     stats.updates.first.profile.id.should == "19408512"
  #     stats.updates.first.profile.first_name.should == 'Vahid'
  #     stats.updates.first.profile.connections.first.id.should == "28072758"
  #     stats.updates.first.profile.connections.first.last_name.should == 'Varone'
  #   end
  #
  #   it "should retrieve network updates" do
  #     stub_get("/v1/people/~/network?type=PICT", "picture_updates.xml")
  #
  #     stats = client.network_updates(:type => "PICT")
  #     stats.updates.size.should == 4
  #     stats.updates.last.profile.headline.should == "Creative Director for Intridea"
  #   end
  #
  #   it "should send a message to recipients" do
  #     stub_post("/v1/people/~/mailbox", "mailbox_items.xml")
  #
  #     recipients = ["~", "abcdefg"]
  #     subject    = "Congratulations on your new position."
  #     body       = "You're certainly the best person for the job!"
  #
  #     client.send_message(subject, body, recipients).should == "201"
  #
  #     expect_post("/v1/people/~/mailbox", "mailbox_items.xml")
  #   end
  #
  #   it "should share a link" do
  #     stub_post("/v1/people/~/shares", "blank.xml")
  #
  #     client.share({
  #       :comment => "Testing out the LinkedIn API",
  #       :title => "Share",
  #       :url => "http://www.linkedin.com",
  #       :image_url => "http://www.linkedin.com/pretty_logo.jpg"
  #     }).code.should == "201"
  #
  #     expect_post("/v1/people/~/shares", "shares.xml")
  #   end
  #
  #   it "should retrieve language information from a profile" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     language = client.profile.languages.last
  #     language.name.should == "Klingon"
  #     language.id.to_i.should == 72
  #   end
  #
  #   it "should retrieve skills from a profile" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     skill = client.profile.skills.last
  #     skill.name.should == "Union negotiations"
  #     skill.id.to_i.should == 38
  #   end
  #
  #   it "should retrieve phone_number from a profile" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     pn = client.profile.phone_numbers.last
  #
  #     pn.phone_type.should == "mobile"
  #     pn.phone_number.should == "+444444444444"
  #   end
  #
  #   it "should retrieve publications from a profile" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     publication = client.profile.publications.last
  #
  #     publication.id.to_i.should == 31
  #     publication.title.should == "How to host an awesome podcast"
  #     publication.date.should == Date.civil(y=2006,m=8,d=1)
  #   end
  #
  #   it "should retrieve patents from a profile" do
  #     stub_get("/v1/people/~", "profile_full.xml")
  #
  #     patent = client.profile.patents.last
  #
  #     patent.id.to_i.should == 51
  #     patent.title.should == "Time machine"
  #     patent.date.should == Date.civil(y=2008,m=7,d=23)
  #   end
  #
  # end

end
