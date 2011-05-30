require 'spec_helper'

describe LinkedIn::Api::CompanyMethods do
  
  # if you remove the related cassettes you will need to inform valid
  # tokens and secrets to regenerate them
  #
  let(:client) do
    consumer_token  = ENV['LINKED_IN_CONSUMER_KEY'] || 'key'
    consumer_secret = ENV['LINKED_IN_CONSUMER_SECRET'] || 'secret'
    client = LinkedIn::Client.new(consumer_token, consumer_secret)
    auth_token      = ENV['LINKED_IN_AUTH_KEY'] || 'key'
    auth_secret     = ENV['LINKED_IN_AUTH_SECRET'] || 'secret'
    client.authorize_from_access(auth_token, auth_secret)
    client
  end
  
  context "Retrieving companies" do
    
    describe "by id" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company(:id => '162479')
      end
      
      it "should get a valid company" do
        result.id.should == 162479
        result.name == 'Apple Inc.'
      end
    end
    
    describe "by id with fields" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company(:id => '162479', :fields => ['id', 'name', 'universal-name', 'email-domains', 'logo-url', 'industry'])
      end
      
      it "should get a valid company" do
        result.id.should == 162479
        result.name == 'Apple Inc.'
        result.universal_name == 'apple-inc'
        result.industry == 'Computer Hardware'
        result.logo_url == 'http://media.linkedin.com/mpr/mpr/p/2/000/082/2e6/39570d2.png'
        result.email_domains.all.size == 30
      end
    end
    
    describe "by universal name" do
      use_vcr_cassette :record => :new_episodes
      
      let(:result) do
        client.company(:universal_name => 'apple-inc')
      end
      
      it "should get a valid company" do
        result.id.should == 162479
        result.name == 'Apple Inc.'
      end
    end
    
    describe "by email domain" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.company(:email_domain => 'apple.com')
      end
      
      it "should get a valid list of companies" do
        results.all.size.should == 2
        results.all.first.id == 162479
        results.all.first.name == 'Apple Inc.'
        results.all.last.id == 1276
        results.all.last.name == 'Apple Retail'
      end
    end
    
  end

end