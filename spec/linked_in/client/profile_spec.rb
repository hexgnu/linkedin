require 'helper'

describe LinkedIn::Client::Profile do

  before do
    @client = LinkedIn::Client.new
  end

  describe ".profile" do
    it "should return the basic profile for the current user" do
      stub_get("/people/~").
        to_return(:body => fixture("basic.json"))
      profile = @client.profile
      profile.first_name.should == "Ryan"
    end

    it "should return the users educations when passing a field" do
      stub_get("/people/~:(educations)").
        to_return(:body => fixture("full_profile.json"))
      profile = @client.profile(:fields => ['educations'])
      profile.educations._total.should == 2
    end

    it "should return the users education and positions when passing multiple fields" do
      stub_get("/people/~:(educations,positions)").
        to_return(:body => fixture("full_profile.json"))
      profile = @client.profile(:fields => ['educations','positions'])
      profile.educations._total.should == 2
      profile.positions._total.should == 2
    end

    it "should return the profile for a connection" do
      stub_get("/people/id=123").
        to_return(:body => fixture("matt_lewis.json"))
      profile = @client.profile(:id => "123")
      profile.first_name.should == "Matt"
    end

  end

  describe ".connections" do
    it "should return the connections in the current users network" do
      stub_get("/people/~/connections").
        to_return(:body => fixture("connections.json"))
      connections = @client.connections
      connections._total.should == 3
    end

    it "should return connections when passing paramaters" do
      stub_get("/people/~/connections?count=2").
        to_return(:body => fixture("connections_params.json"))
      connections = @client.connections({},:count => 2)
      connections._count.should == 2
    end
  end

  describe ".search" do
    it "should return the people search for the current users network" do
      stub_get("/people-search").
        to_return(:body => fixture("people_search.json"))
      search = @client.search
      search.people._total.should == 110
    end

    it "should return a search with people keyword Ruby" do
      stub_get("/people-search?keywords=ruby").
        to_return(:body => fixture("people_search_ruby.json"))
      search = @client.search(:keywords => "ruby")
      search.people._count.should == 10
    end

    it "should return a search with first and last name" do
      stub_get("/people-search?first-name=matt&last-name=lewis").
        to_return(:body => fixture("people_search_matt_lewis.json"))
      search = @client.search(:first_name => "matt", :last_name => "lewis")
      search.num_results.should == 637
    end

  end

end
