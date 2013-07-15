require 'helper'

describe "LinkedIn::Client" do

  let(:client) do
    client_id    = ENV['LINKED_IN_CLIENT_KEY'] || '1234'
    client_secret = ENV['LINKED_IN_CLIENT_SECRET'] || '1234'
    LinkedIn::Client.new(client_id, client_secret)
  end

  describe "#consumer" do
    describe "default oauth options" do
      let(:consumer) { client.consumer }

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.linkedin.com'
        consumer.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        consumer.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end

    describe "proxy oauth options" do
      let(:proxy) { "http://dummy.proxy" }
      let(:consumer) do
        LinkedIn::Client.new('1234', '1234', {
          :proxy => proxy,
        }).consumer
      end

      it "should send requests though proxy" do
        consumer.proxy.should eq proxy
      end
    end

    describe "different api and auth hosts options" do
      let(:consumer) do
        LinkedIn::Client.new('1234', '1234', {
          :api_host => 'https://api.josh.com',
          :auth_host => 'https://www.josh.com'
        }).consumer
      end

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.josh.com'
        consumer.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        consumer.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end

    describe "different oauth paths" do
      let(:consumer) do
        LinkedIn::Client.new('1234', '1234', {
          :authorize_path     => "/secure/oauth/authorize",
          :access_token_path  => "/secure/oauth/accessToken",
        }).consumer
      end

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.linkedin.com'
        consumer.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        consumer.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end

    describe "specify oauth urls" do
      let(:consumer) do
        LinkedIn::Client.new('1234', '1234', {
          :token_url => "https://api.josh.com/secure/oauth/requestToken",
          :authorize_url  => "https://api.josh.com/secure/oauth/accessToken",
          :authorize_url     => "https://www.josh.com/secure/oauth/authorize",
        }).consumer
      end

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.linkedin.com'
        consumer.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        consumer.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end

    describe "use the :site option to specify the host of all oauth urls" do
      let(:consumer) do
        LinkedIn::Client.new('1234', '1234', {
          :site => "https://api.josh.com"
        }).consumer
      end

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.josh.com'
        consumer.token_url.should == "https://www.linkedin.com/uas/oauth2/accessToken"
        consumer.authorize_url.should == "https://www.linkedin.com/uas/oauth2/authorization"
      end
    end
  end

  describe "#get_token" do
    describe "with default options" do
      use_vcr_cassette :record => :new_episodes

      it "should return a valid request token" do
        access_token = client.get_token

        access_token.should be_a_kind_of OAuth::RequestToken
        access_token.authorize_url.should include("https://www.linkedin.com/uas/oauth/authorize?oauth_token=")

        a_request(:post, "https://api.linkedin.com/uas/oauth/requestToken").should have_been_made.once
      end
    end

    describe "with a callback url" do
      use_vcr_cassette :record => :new_episodes

      it "should return a valid access token" do
        access_token = client.access_token(:oauth_callback => 'http://www.josh.com')

        access_token.should be_a_kind_of OAuth::RequestToken
        access_token.authorize_url.should include("https://www.linkedin.com/uas/oauth/authorize?oauth_token=")
        access_token.callback_confirmed?.should == true

        a_request(:post, "https://api.linkedin.com/uas/oauth/requestToken").should have_been_made.once
      end
    end
  end

  describe "#authorize_from_request" do
    let(:access_token) do
      # if you remove the related casssette you will need to do the following
      # authorize_from_request request manually
      #
      # access_token = client.access_token
      # puts "token    : #{access_token.token} - secret #{access_token.secret}"
      # puts "auth url : #{access_token.authorize_url}"
      # raise 'keep note of the token and secret'
      #
      client.authorize_from_request('dummy-token', 'dummy-secret', 'dummy-pin')
    end

    use_vcr_cassette :record => :new_episodes, :match_requests_on => [:uri, :method]

    it "should return a valid access token" do
      access_token.should be_a_kind_of Array
      access_token[0].should be_a_kind_of String
      access_token[1].should be_a_kind_of String

      a_request(:post, "https://api.linkedin.com/uas/oauth/accessToken").should have_been_made.once
    end
  end

  describe "#access_token" do
    let(:access_token) do
      client.authorize_from_access('dummy-token', 'dummy-secret')
      client.access_token
    end

    it "should return a valid auth token" do
      access_token.should be_a_kind_of OAuth::AccessToken
      access_token.token.should be_a_kind_of String
    end
  end

  describe "#authorize_from_access" do
    let(:auth_token) do
      client.authorize_from_access('dummy-token', 'dummy-secret')
    end

    it "should return a valid auth token" do
      auth_token.should be_a_kind_of Array
      auth_token[0].should be_a_kind_of String
      auth_token[1].should be_a_kind_of String
    end
  end

end
