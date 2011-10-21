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

  describe ".current_share" do
    it "should return the users current share" do
      stub_get("/people/~:(current-share)").
        to_return(:body => fixture("current_share.json"))
      current_share = @client.current_share
      current_share.current_share.author.first_name.should == "Ryan"
    end
  end

  describe ".network_stats" do
    it "should return the network statistics for teh user" do
      stub_get("/people/~/network/network-stats").
        to_return(:body => fixture("network_stats.json"))
      net_stats = @client.network_stats
      net_stats._total.should == 2
    end
  end

end
