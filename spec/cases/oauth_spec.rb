require 'helper'

describe "LinkedIn::Client" do

  let(:client) do
    key    = ENV['LINKED_IN_CONSUMER_KEY'] || '1234'
    secret = ENV['LINKED_IN_CONSUMER_SECRET'] || '1234'
    LinkedIn::Client.new(key, secret)
  end

  describe "#consumer" do
    describe "default oauth options" do
      let(:consumer) { client.consumer }

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.linkedin.com'
        consumer.request_token_url.should == 'https://api.linkedin.com/uas/oauth/requestToken'
        consumer.access_token_url.should == 'https://api.linkedin.com/uas/oauth/accessToken'
        consumer.authorize_url.should == 'https://www.linkedin.com/uas/oauth/authorize'
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
        consumer.request_token_url.should == 'https://api.josh.com/uas/oauth/requestToken'
        consumer.access_token_url.should == 'https://api.josh.com/uas/oauth/accessToken'
        consumer.authorize_url.should == 'https://www.josh.com/uas/oauth/authorize'
      end
    end

    describe "different oauth paths" do
      let(:consumer) do
        LinkedIn::Client.new('1234', '1234', {
          :request_token_path => "/secure/oauth/requestToken",
          :access_token_path  => "/secure/oauth/accessToken",
          :authorize_path     => "/secure/oauth/authorize",
        }).consumer
      end

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.linkedin.com'
        consumer.request_token_url.should == 'https://api.linkedin.com/secure/oauth/requestToken'
        consumer.access_token_url.should == 'https://api.linkedin.com/secure/oauth/accessToken'
        consumer.authorize_url.should == 'https://www.linkedin.com/secure/oauth/authorize'
      end
    end

    describe "specify oauth urls" do
      let(:consumer) do
        LinkedIn::Client.new('1234', '1234', {
          :request_token_url => "https://api.josh.com/secure/oauth/requestToken",
          :access_token_url  => "https://api.josh.com/secure/oauth/accessToken",
          :authorize_url     => "https://www.josh.com/secure/oauth/authorize",
        }).consumer
      end

      it "should return a configured OAuth consumer" do
        consumer.site.should == 'https://api.linkedin.com'
        consumer.request_token_url.should == 'https://api.josh.com/secure/oauth/requestToken'
        consumer.access_token_url.should == 'https://api.josh.com/secure/oauth/accessToken'
        consumer.authorize_url.should == 'https://www.josh.com/secure/oauth/authorize'
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
        consumer.request_token_url.should == 'https://api.josh.com/uas/oauth/requestToken'
        consumer.access_token_url.should == 'https://api.josh.com/uas/oauth/accessToken'
        consumer.authorize_url.should == 'https://api.josh.com/uas/oauth/authorize'
      end
    end
  end

  describe "#request_token" do
    describe "with default options" do
      use_vcr_cassette :record => :new_episodes

      it "should return a valid request token" do
        request_token = client.request_token

        request_token.should be_a_kind_of OAuth::RequestToken
        request_token.authorize_url.should include("https://www.linkedin.com/uas/oauth/authorize?oauth_token=")

        a_request(:post, "https://api.linkedin.com/uas/oauth/requestToken").should have_been_made.once
      end
    end

    describe "with a callback url" do
      use_vcr_cassette :record => :new_episodes

      it "should return a valid access token" do
        request_token = client.request_token(:oauth_callback => 'http://www.josh.com')

        request_token.should be_a_kind_of OAuth::RequestToken
        request_token.authorize_url.should include("https://www.linkedin.com/uas/oauth/authorize?oauth_token=")
        request_token.callback_confirmed?.should == true

        a_request(:post, "https://api.linkedin.com/uas/oauth/requestToken").should have_been_made.once
      end
    end
  end

  describe "#authorize_from_request" do
    let(:access_token) do
      # if you remove the related casssette you will need to do the following
      # authorize_from_request request manually
      #
      # request_token = client.request_token
      # puts "token    : #{request_token.token} - secret #{request_token.secret}"
      # puts "auth url : #{request_token.authorize_url}"
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
