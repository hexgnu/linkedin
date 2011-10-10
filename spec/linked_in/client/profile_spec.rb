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
      profile.firstName.should == "Ryan"
    end
  end

  describe ".connections" do
    it "should return the connections in the current users network" do
      stub_get("/people/~/connections").
        to_return(:body => fixture("connections.json"))
      connections = @client.connections
      connections.values.last.first.firstName.should == "Matt"
    end

  end

end
