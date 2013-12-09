require 'helper'

describe LinkedIn::Api do
  before do
    LinkedIn.default_profile_fields = nil
    client.stub(:consumer).and_return(consumer)
    client.authorize_from_access('atoken', 'asecret')
  end

  let(:client){LinkedIn::Client.new('token', 'secret')}
  let(:consumer){OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})}

  it "should be able to view the account profile" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}")
    client.profile.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view public profiles" do
    stub_request(:get, "https://api.linkedin.com/v1/people/id=123").to_return(:body => "{}")
    client.profile(:id => 123).should be_an_instance_of(LinkedIn::Mash)
  end
  
  it "should be able to view the picture urls" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/picture-urls::(original)").to_return(:body => "{}")
    client.picture_urls.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view connections" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/connections").to_return(:body => "{}")
    client.connections.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_updates" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates").to_return(:body => "{}")
    client.network_updates.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_update's comments" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/update-comments").to_return(:body => "{}")
    client.share_comments("network_update_key").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_update's likes" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/likes").to_return(:body => "{}")
    client.share_likes("network_update_key").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to search with a keyword if given a String" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search?keywords=business").to_return(:body => "{}")
    client.search("business").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to search with an option" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search?first-name=Javan").to_return(:body => "{}")
    client.search(:first_name => "Javan").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to search with an option and fetch specific fields" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search:(num-results,total)?first-name=Javan").to_return(
        :body => "{}")
    client.search(:first_name => "Javan", :fields => ["num_results", "total"]).should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to share a new status" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/shares").to_return(:body => "", :status => 201)
    response = client.add_share(:comment => "Testing, 1, 2, 3")
    response.body.should == nil
    response.code.should == "201"
  end

  it "should be able to share a new company status" do
    stub_request(:post, "https://api.linkedin.com/v1/companies/123456/shares").to_return(:body => "", :status => 201)
    response = client.add_company_share("123456", { :comment => "Testing, 1, 2, 3" })
    response.body.should == nil
    response.code.should == "201"
  end

  it "returns the shares for a person" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates?type=SHAR&scope=self&after=1234&count=35").to_return(
      :body => "{}")
    client.shares(:after => 1234, :count => 35)
  end

  it "should be able to comment on network update" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/update-comments").to_return(
        :body => "", :status => 201)
    response = client.update_comment('SOMEKEY', "Testing, 1, 2, 3")
    response.body.should == nil
    response.code.should == "201"
  end

  it "should be able to like a network update" do
    stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked").
      with(:body => "true").to_return(:body => "", :status => 201)
    response = client.like_share('SOMEKEY')
    response.body.should == nil
    response.code.should == "201"
  end

  it "should be able to unlike a network update" do
    stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked").
      with(:body => "false").to_return(:body => "", :status => 201)
    response = client.unlike_share('SOMEKEY')
    response.body.should == nil
    response.code.should == "201"
  end

  it "should be able to pass down the additional arguments to OAuth's get_request_token" do
    consumer.should_receive(:get_request_token).with(
      {:oauth_callback => "http://localhost:3000/auth/callback"},  :scope => "rw_nus").and_return("request_token")

    request_token = client.request_token(
      {:oauth_callback => "http://localhost:3000/auth/callback"},  :scope => "rw_nus"
    )

    request_token.should == "request_token"
  end

  context "Company API" do
    use_vcr_cassette

    it "should be able to view a company profile" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586").to_return(:body => "{}")
      client.company(:id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view a company by universal name" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/universal-name=acme").to_return(:body => "{}")
      client.company(:name => 'acme').should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view a company by e-mail domain" do
      stub_request(:get, "https://api.linkedin.com/v1/companies?email-domain=acme.com").to_return(:body => "{}")
      client.company(:domain => 'acme.com').should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view a user's company pages" do
      stub_request(:get, "https://api.linkedin.com/v1/companies?is-company-admin=true").to_return(:body => "{}")
      client.company(:is_admin => 'true').should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to page a user's company pages" do
      stub_request(:get, "https://api.linkedin.com/v1/companies?is-company-admin=true&count=10&start=0").to_return(:body => "{}")
      client.company(:is_admin => 'true', :count => 10, :start => 0).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should load correct company data" do
      client.company(:id => 1586).name.should == "Amazon"

      data = client.company(:id => 1586, :fields => %w{ id name industry locations:(address:(city state country-code) is-headquarters) employee-count-range })
      data.id.should == 1586
      data.name.should == "Amazon"
      data.employee_count_range.name.should == "10001+"
      data.industry.should == "Internet"
      data.locations.all[0].address.city.should == "Seattle"
      data.locations.all[0].is_headquarters.should == true
    end

    it "should be able to view company_updates" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586/updates").to_return(:body => "{}")
      client.company_updates(:id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view company_statistic" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586/company-statistics").to_return(:body => "{}")
      client.company_statistics(:id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view company updates comments" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586/updates/key=company_update_key/update-comments").to_return(:body => "{}")
      client.company_updates_comments("company_update_key", :id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view company updates likes" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586/updates/key=company_update_key/likes").to_return(:body => "{}")
      client.company_updates_likes("company_update_key", :id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to follow a company" do
      stub_request(:post, "https://api.linkedin.com/v1/people/~/following/companies").to_return(:body => "", :status => 201)

      response = client.follow_company(1586)
      response.body.should == nil
      response.code.should == "201"
    end

    it "should be able to unfollow a company" do
      stub_request(:delete, "https://api.linkedin.com/v1/people/~/following/companies/id=1586").to_return(:body => "", :status => 201)

      response = client.unfollow_company(1586)
      response.body.should == nil
      response.code.should == "201"
    end

  end

  context "Job API" do
    use_vcr_cassette

    it "should be able to view a job listing" do
      stub_request(:get, "https://api.linkedin.com/v1/jobs/id=1586").to_return(:body => "{}")
      client.job(:id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view its job bookmarks" do
      stub_request(:get, "https://api.linkedin.com/v1/people/~/job-bookmarks").to_return(:body => "{}")
      client.job_bookmarks.should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view its job suggestion" do
      stub_request(:get, "https://api.linkedin.com/v1/people/~/suggestions/job-suggestions").to_return(:body => "{}")
      client.job_suggestions.should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to add a bookmark" do
      stub_request(:post, "https://api.linkedin.com/v1/people/~/job-bookmarks").to_return(:body => "", :status => 201)
      response = client.add_job_bookmark(:id => 1452577)
      response.body.should == nil
      response.code.should == "201"
    end
  end

  context "Group API" do

    it "should be able to list group memberships for a profile" do
      stub_request(:get, "https://api.linkedin.com/v1/people/~/group-memberships").to_return(:body => "{}")
      client.group_memberships.should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to join a group" do
      stub_request(:put, "https://api.linkedin.com/v1/people/~/group-memberships/123").to_return(:body => "", :status => 201)

      response = client.join_group(123)
      response.body.should == nil
      response.code.should == "201"
    end

    it "should be able to list a group profile" do
      stub_request(:get, "https://api.linkedin.com/v1/groups/123").to_return(:body => '{"id": "123"}')
      response = client.group_profile(:id => 123)
      response.id.should == '123'
    end

    it "should be able to list group posts" do
      stub_request(:get, "https://api.linkedin.com/v1/groups/123/posts").to_return(:body => '{"id": "123"}')
      response = client.group_posts(:id => 123)
      response.id.should == '123'
    end

    it 'should be able to post a discussion to a group' do
      expected = {
        'title' => 'New Discussion',
        'summary' => 'New Summary',
        'content' => {
          "submitted-url" => "http://www.google.com"
        }
      }

      stub_request(:post, "https://api.linkedin.com/v1/groups/123/posts").with(:body => expected).to_return(:body => "", :status => 201)
      response = client.post_group_discussion(123, expected)
      response.body.should == nil
      response.code.should == '201'
    end
  end

  context "Communication API" do
    it "should be able to send a message" do
      stub_request(:post, "https://api.linkedin.com/v1/people/~/mailbox").to_return(:body => "", :status => 201)
      response = client.send_message("subject", "body", ["recip1", "recip2"])
      response.body.should == nil
      response.code.should == "201"
    end
  end

  context "Errors" do
    it "should raise AccessDeniedError when LinkedIn returns 403 status code" do
      stub_request(:get, "https://api.linkedin.com/v1/people-search?first-name=Javan").to_return(:body => "{}", :status => 403)
      expect{ client.search(:first_name => "Javan") }.to raise_error(LinkedIn::Errors::AccessDeniedError)
    end
  end
end
