require 'helper'

describe LinkedIn::Client::Profile do

  before do
    @client = LinkedIn::Client.new
  end

  describe ".profile" do
    it "should return the basic profile for the current user" do
      stub_get("https://api.linkedin.com/v1/people/~").
        to_return(:body => fixture("basic.json"))
      profile = @client.profile
      profile.firstName.should == "Ryan"
    end
  end

end
