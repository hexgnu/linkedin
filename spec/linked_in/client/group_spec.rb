require 'helper'

describe LinkedIn::Client::Group do

  before do
    @client = LinkedIn::Client.new
  end

  describe ".group" do
    it "should return the group of the id" do
      stub_get("/groups/120725").
        to_return(:body => fixture("group_ruby.json"))
      group = @client.group(120725)
      group.name == "Rubyists"
    end
  end
end
