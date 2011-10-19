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
      group.name.should == "Rubyists"
    end

    it "should return a group when passing multiple fields" do
      stub_get("/groups/120725:(id,name,site-group-url,posts)").
        to_return(:body => fixture("group_ruby.json"))
      group = @client.group(120725, :fields => ['id','name','site-group-url','posts'])
      group.site_group_url.should == "http://www.linkedin.com/groups?gid=120725&trk=api*a133056*s141444*"
    end
  end
end
