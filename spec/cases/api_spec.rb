require 'helper'

describe LinkedIn::Api do
  before do
    LinkedIn.default_profile_fields = nil
  end

  let(:client){LinkedIn::Client.new('stub_client_id',
                                    'stub_client_secret',
                                    'stub_access_token')}

  it "should be able to view the account profile" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.profile.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view public profiles" do
    stub_request(:get, "https://api.linkedin.com/v1/people/id=123?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.profile(:id => 123).should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view connections" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/connections?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.connections.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_updates" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.network_updates.should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_update's comments" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/update-comments?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.share_comments("network_update_key").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to view network_update's likes" do
    stub_request(:get, "https://api.linkedin.com/v1/people/~/network/updates/key=network_update_key/likes?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.share_likes("network_update_key").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to search with a keyword if given a String" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search?keywords=business&oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.search("business").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to search with an option" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search?first-name=Javan&oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
    client.search(:first_name => "Javan").should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to search with an option and fetch specific fields" do
    stub_request(:get, "https://api.linkedin.com/v1/people-search:(num-results,total)?first-name=Javan&oauth2_access_token=#{client.access_token.token}").to_return(
        :body => "{}")
    client.search(:first_name => "Javan", :fields => ["num_results", "total"]).should be_an_instance_of(LinkedIn::Mash)
  end

  it "should be able to share a new status" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/shares?oauth2_access_token=#{client.access_token.token}").to_return(:body => "", :status => 201)
    response = client.add_share(:comment => "Testing, 1, 2, 3")
    response.body.should == ""
    response.status.should == 201
  end

  it "should be able to comment on network update" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/update-comments?oauth2_access_token=#{client.access_token.token}").to_return(
        :body => "", :status => 201)
    response = client.update_comment('SOMEKEY', "Testing, 1, 2, 3")
    response.body.should == ""
    response.status.should == 201
  end

  it "should be able to send a message" do
    stub_request(:post, "https://api.linkedin.com/v1/people/~/mailbox?oauth2_access_token=#{client.access_token.token}").to_return(:body => "", :status => 201)
    response = client.send_message("subject", "body", ["recip1", "recip2"])
    response.body.should == ""
    response.status.should == 201
  end

  it "should be able to like a network update" do
    stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked?oauth2_access_token=#{client.access_token.token}").
      with(:body => "true").to_return(:body => "", :status => 201)
    response = client.like_share('SOMEKEY')
    response.body.should == ""
    response.status.should == 201
  end

  it "should be able to unlike a network update" do
    stub_request(:put, "https://api.linkedin.com/v1/people/~/network/updates/key=SOMEKEY/is-liked?oauth2_access_token=#{client.access_token.token}").
      with(:body => "false").to_return(:body => "", :status => 201)
    response = client.unlike_share('SOMEKEY')
    response.body.should == ""
    response.status.should == 201
  end

  it "should be able to pass down the additional arguments to OAuth's request_access_token" do
# 
#     stub_request(:post, "https://www.linkedin.com/uas/oauth2/accessToken").with { |r| r.body == "grant_type=authorization_code&code=auth_code&client_id=stub_client_id&client_secret=stub_client_secret&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth%2Fcallback" }
# 
#     access_token = client.request_access_token("auth_code",
#       {:redirect_uri => "http://localhost:3000/auth/callback"})

    c = LinkedIn::Client.new('stub_client_id',
                             'stub_client_secret',
                             'stub_access_token',
                             {site: "some_other_site"})

    c.oauth2_client.site == "some_other_site"
  end

  context "Company API" do
    use_vcr_cassette

    it "should be able to view a company profile" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
      client.company(:id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view a company by universal name" do
      stub_request(:get, "https://api.linkedin.com/v1/companies/universal-name=acme?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
      client.company(:name => 'acme').should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view a company by e-mail domain" do
      stub_request(:get, "https://api.linkedin.com/v1/companies?email-domain=acme.com&oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
      client.company(:domain => 'acme.com').should be_an_instance_of(LinkedIn::Mash)
    end

    it "should load correct company data" do
      client.company(:id => 1586).name.should == "Amazon"

      stub_request(:get, "https://api.linkedin.com/v1/companies/id=1586?oauth2_access_token=stub_access_token").to_return(body: "{}")

      data = client.company(:id => 1586, :fields => %w{ id name industry locations:(address:(city state country-code) is-headquarters) employee-count-range })
      data.id.should == 1586
      data.name.should == "Amazon"
      data.employee_count_range.name.should == "10001+"
      data.industry.should == "Internet"
      data.locations.all[0].address.city.should == "Seattle"
      data.locations.all[0].is_headquarters.should == true
    end
  end

  context "Job API" do
    use_vcr_cassette

    it "should be able to view a job listing" do
      stub_request(:get, "https://api.linkedin.com/v1/jobs/id=1586?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
      client.job(:id => 1586).should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view its job bookmarks" do
      stub_request(:get, "https://api.linkedin.com/v1/people/~/job-bookmarks?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
      client.job_bookmarks.should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to view its job suggestion" do
      stub_request(:get, "https://api.linkedin.com/v1/people/~/suggestions/job-suggestions?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
      client.job_suggestions.should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to add a bookmark" do
      stub_request(:post, "https://api.linkedin.com/v1/people/~/job-bookmarks?oauth2_access_token=#{client.access_token.token}").to_return(:body => "", :status => 201)
      response = client.add_job_bookmark(:id => 1452577)
      response.body.should == ""
      response.status.should == 201
    end
  end

  context "Group API" do

    it "should be able to list group memberships for a profile" do
      stub_request(:get, "https://api.linkedin.com/v1/people/~/group-memberships?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}")
      client.group_memberships.should be_an_instance_of(LinkedIn::Mash)
    end

    it "should be able to join a group" do
      stub_request(:put, "https://api.linkedin.com/v1/people/~/group-memberships/123?oauth2_access_token=#{client.access_token.token}").to_return(:body => "", :status => 201)

      response = client.join_group(123)
      response.body.should == ""
      response.status.should == 201
    end

  end

  context "errors" do
    it "should raise access denied error when linkedin returns 403 status code" do
      stub_request(:get, "https://api.linkedin.com/v1/people-search?first-name=javan?oauth2_access_token=#{client.access_token.token}").to_return(:body => "{}", :status => 403)
      expect{ client.search(:first_name => "javan") }.to raise_error(LinkedIn::Errors::AccessDeniedError)
    end
  end
end
