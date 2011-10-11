require 'helper'

describe LinkedIn::Client::SocialStream do

  before do
    @client = LinkedIn::Client.new
  end

  describe ".network_updates" do
    it "should return the network udpates for the current user" do
      stub_get("/people/~/network/updates").
        to_return(:body => fixture("network_updates.json"))
      network_updates = @client.network_updates
      network_updates._count.should == 10
    end
  end
end
