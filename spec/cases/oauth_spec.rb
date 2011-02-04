require 'spec_helper'

describe "LinkedIn::Client OAuth" do
  let(:client) { LinkedIn::Client.new('token', 'secret') }
  
  it "should initialize with consumer token and secret" do
    client.ctoken.should == 'token'
    client.csecret.should == 'secret'
  end

  it "should set authorization path to '/uas/oauth/authorize' by default" do
    client.consumer.options[:authorize_path].should == '/uas/oauth/authorize'
  end

  it "should have a consumer" do
    consumer = mock('oauth consumer')
    options = {
      :request_token_path => "/uas/oauth/requestToken",
      :access_token_path  => "/uas/oauth/accessToken",
      :authorize_path     => "/uas/oauth/authorize",
      :site => 'https://api.linkedin.com'
    }
    OAuth::Consumer.should_receive(:new).with('token', 'secret', options).and_return(consumer)

    client.consumer.should == consumer
  end

  it "should have a request token from the consumer" do
    options = {
      :request_token_path => "/uas/oauth/requestToken",
      :access_token_path  => "/uas/oauth/accessToken",
      :authorize_path     => "/uas/oauth/authorize",
      :site => 'https://api.linkedin.com'
    }
    consumer = mock('oauth consumer')
    request_token = mock('request token')
    consumer.should_receive(:get_request_token).and_return(request_token)
    OAuth::Consumer.should_receive(:new).with('token', 'secret', options).and_return(consumer)

    client.request_token.should == request_token
  end

  it "#set_callback_url should clear the request token and set the callback url" do
    consumer = mock('oauth consumer')
    request_token = mock('request token')
    options = {
            :request_token_path => "/uas/oauth/requestToken",
            :access_token_path  => "/uas/oauth/accessToken",
            :authorize_path     => "/uas/oauth/authorize",
            :site => 'https://api.linkedin.com'
          }
    OAuth::Consumer.
      should_receive(:new).
      with('token', 'secret', options).
      and_return(consumer)

    linkedin = LinkedIn::Client.new('token', 'secret')

    consumer.
      should_receive(:get_request_token).
      with({:oauth_callback => 'http://myapp.com/oauth_callback'})

    linkedin.set_callback_url('http://myapp.com/oauth_callback')
  end

  it "should be able to create access token from request token, request secret and verifier" do
    consumer = OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})
    client.stub(:consumer).and_return(consumer)

    access_token  = mock('access token', :token => 'atoken', :secret => 'asecret')
    request_token = mock('request token')
    request_token.
      should_receive(:get_access_token).
      with(:oauth_verifier => 'verifier').
      and_return(access_token)

    OAuth::RequestToken.
      should_receive(:new).
      with(consumer, 'rtoken', 'rsecret').
      and_return(request_token)

    client.authorize_from_request('rtoken', 'rsecret', 'verifier')
    client.access_token.class.should be(OAuth::AccessToken)
    client.access_token.token.should == 'atoken'
    client.access_token.secret.should == 'asecret'
  end

  it "should be able to create access token from access token and secret" do
    consumer = OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})
    client.stub(:consumer).and_return(consumer)

    client.authorize_from_access('atoken', 'asecret')
    client.access_token.class.should be(OAuth::AccessToken)
    client.access_token.token.should == 'atoken'
    client.access_token.secret.should == 'asecret'
  end

  it "should be able to configure consumer token and consumer secret without passing to initialize" do
    LinkedIn.configure do |config|
      config.token = 'consumer_token'
      config.secret = 'consumer_secret'
    end

    linkedin = LinkedIn::Client.new
    linkedin.ctoken.should == 'consumer_token'
    linkedin.csecret.should == 'consumer_secret'
  end

end