require 'test_helper'

class OAuthTest < Test::Unit::TestCase
  should "initialize with consumer token and secret" do
    linkedin = LinkedIn::Client.new('token', 'secret')
    
    linkedin.ctoken.should == 'token'
    linkedin.csecret.should == 'secret'
  end
  
  should "set authorization path to '/uas/oauth/authorize' by default" do
    linkedin = LinkedIn::Client.new('token', 'secret')
    linkedin.consumer.options[:authorize_path].should == '/uas/oauth/authorize'
  end
  
  should "have a consumer" do
    consumer = mock('oauth consumer')
    options = { 
            :request_token_path => "/uas/oauth/requestToken",
            :access_token_path  => "/uas/oauth/accessToken",
            :authorize_path     => "/uas/oauth/authorize",
            :site => 'https://api.linkedin.com'
          }
    OAuth::Consumer.expects(:new).with('token', 'secret', options).returns(consumer)
    linkedin = LinkedIn::Client.new('token', 'secret')
    
    linkedin.consumer.should == consumer
  end
  
  should "have a request token from the consumer" do
    options = { 
            :request_token_path => "/uas/oauth/requestToken",
            :access_token_path  => "/uas/oauth/accessToken",
            :authorize_path     => "/uas/oauth/authorize",
            :site => 'https://api.linkedin.com'
          }
    consumer = mock('oauth consumer')
    request_token = mock('request token')
    consumer.expects(:get_request_token).returns(request_token)
    OAuth::Consumer.expects(:new).with('token', 'secret', options).returns(consumer)
    linkedin = LinkedIn::Client.new('token', 'secret')
    
    linkedin.request_token.should == request_token
  end
  
  context "set_callback_url" do
    should "clear request token and set the callback url" do
      consumer = mock('oauth consumer')
      request_token = mock('request token')
      options = { 
              :request_token_path => "/uas/oauth/requestToken",
              :access_token_path  => "/uas/oauth/accessToken",
              :authorize_path     => "/uas/oauth/authorize",
              :site => 'https://api.linkedin.com'
            }
      OAuth::Consumer.
        expects(:new).
        with('token', 'secret', options).
        returns(consumer)
      
      linkedin = LinkedIn::Client.new('token', 'secret')
      
      consumer.
        expects(:get_request_token).
        with({:oauth_callback => 'http://myapp.com/oauth_callback'})
      
      linkedin.set_callback_url('http://myapp.com/oauth_callback')
    end
  end
  
  should "be able to create access token from request token, request secret and verifier" do
    linkedin = LinkedIn::Client.new('token', 'secret')
    consumer = OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})
    linkedin.stubs(:consumer).returns(consumer)
    
    access_token  = mock('access token', :token => 'atoken', :secret => 'asecret')
    request_token = mock('request token')
    request_token.
      expects(:get_access_token).
      with(:oauth_verifier => 'verifier').
      returns(access_token)
      
    OAuth::RequestToken.
      expects(:new).
      with(consumer, 'rtoken', 'rsecret').
      returns(request_token)
    
    linkedin.authorize_from_request('rtoken', 'rsecret', 'verifier')
    linkedin.access_token.class.should be(OAuth::AccessToken)
    linkedin.access_token.token.should == 'atoken'
    linkedin.access_token.secret.should == 'asecret'
  end
  
  should "be able to create access token from access token and secret" do
    linkedin = LinkedIn::Client.new('token', 'secret')
    consumer = OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})
    linkedin.stubs(:consumer).returns(consumer)
    
    linkedin.authorize_from_access('atoken', 'asecret')
    linkedin.access_token.class.should be(OAuth::AccessToken)
    linkedin.access_token.token.should == 'atoken'
    linkedin.access_token.secret.should == 'asecret'
  end
  
  should "be able to configure consumer token and consumer secret without passing to initialize" do
    LinkedIn.configure do |config|
      config.token = 'consumer_token'
      config.secret = 'consumer_secret'
    end
    
    linkedin = LinkedIn::Client.new
    linkedin.ctoken.should == 'consumer_token'
    linkedin.csecret.should == 'consumer_secret'
  end
  

end