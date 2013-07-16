require 'helper'

describe "LinkedIn::Client" do

  let(:client) do
    client_id    = ENV['LINKED_IN_CLIENT_KEY'] || 'stub_client_id'
    client_secret = ENV['LINKED_IN_CLIENT_SECRET'] || 'stub_client_secret'
    LinkedIn::Client.new(client_id, client_secret)
  end

  let(:authed_client) do
    client_id    = ENV['LINKED_IN_CLIENT_KEY'] || 'stub_client_id'
    client_secret = ENV['LINKED_IN_CLIENT_SECRET'] || 'stub_client_secret'
    access_token = ENV['LINKED_IN_ACCESS_TOKEN'] || 'stub_access_token'
    LinkedIn::Client.new(client_id, client_secret, access_token)
  end

  describe "#oauth2_client" do
    describe "default oauth options" do
      let(:oauth2_client) { client.oauth2_client }

      it "should return a configured OAuth oauth2_client" do
        oauth2_client.site.should == 'https://api.linkedin.com'
        oauth2_client.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        oauth2_client.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end

    describe "different api and auth hosts options" do
      let(:oauth2_client) do
        LinkedIn::Client.new('1234', '1234', {
          :token_url => 'https://token-url.com',
          :authorize_url => 'https://authorize-url.com',
          :site => "https://foo.com"
        }).oauth2_client
      end

      it "should return a configured OAuth oauth2_client" do
        oauth2_client.site.should == 'https://foo.com'
        oauth2_client.token_url.should == "https://token-url.com"
        oauth2_client.authorize_url.should == "https://authorize-url.com"
      end
    end

    describe "different oauth paths" do
      let(:oauth2_client) do
        LinkedIn::Client.new('1234', '1234', {
          :authorize_path     => "/secure/oauth/authorize",
          :access_token_path  => "/secure/oauth/accessToken",
        }).oauth2_client
      end

      it "should return a configured OAuth oauth2_client" do
        oauth2_client.site.should == 'https://api.linkedin.com'
        oauth2_client.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        oauth2_client.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end

    describe "specify oauth urls" do
      let(:oauth2_client) do
        LinkedIn::Client.new('1234', '1234', {
          :token_url => "https://api.josh.com/secure/oauth/requestToken",
          :authorize_url  => "https://api.josh.com/secure/oauth/accessToken",
        }).oauth2_client
      end

      it "should return a configured OAuth oauth2_client" do
        oauth2_client.site.should == 'https://api.linkedin.com'
        oauth2_client.token_url.should == "https://api.josh.com/secure/oauth/requestToken"
        # oauth2_client.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end

    describe "use the :site option to specify the host of all oauth urls" do
      let(:oauth2_client) do
        LinkedIn::Client.new('1234', '1234', {
          :site => "https://api.josh.com"
        }).oauth2_client
      end

      it "should return a configured OAuth oauth2_client" do
        oauth2_client.site.should == 'https://api.josh.com'
        oauth2_client.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        # oauth2_client.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end
  end

  # describe "#request_access_token" do
  #   before(:each) do
  #     stub_request(:post, "https://www.linkedin.com/uas/oauth/accessToken?oauth2_access_token=#{client.access_token.token}").to_return(body: {access_token: "stub_access_token"})
  #   end

  #   describe "with default options" do
  #     use_vcr_cassette :record => :new_episodes

  #     it "should return a valid request token" do
  #       access_token = client.request_access_token("stub_code")
  #       a_request(:post, "https://www.linkedin.com/uas/oauth/accessToken").should have_been_made.once
  #       access_token.should be_a_kind_of OAuth2::AccessToken
  #     end
  #   end

  #   describe "with a callback url" do
  #     use_vcr_cassette :record => :new_episodes

  #     it "should return a valid access token" do
  #       access_token = client.request_access_token("stub_code", redirect_uri: 'http://www.josh.com')
  #       a_request(:post, "https://www.linkedin.com/uas/oauth/accessToken").should have_been_made.once
  #       access_token.should be_a_kind_of OAuth2::RequestToken

  #       access_token.callback_confirmed?.should == true

  #     end
  #   end
  # end

  describe "#access_token" do
    let(:access_token) do
      authed_client.access_token
    end

    it "should return a valid auth token" do
      access_token.should be_a_kind_of OAuth2::AccessToken
      access_token.token.should be_a_kind_of String
    end
  end

end
