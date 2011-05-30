require 'spec_helper'

describe LinkedIn::Search do
  
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
  
  describe "#search" do
    
    describe "by keywords string parameter" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search('github')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 10
        results.people.all.first.first_name.should == 'Giliardi'
        results.people.all.first.last_name.should == 'Pires'
        results.people.all.first.id.should == 'YkdnFl04s_'
      end
    end
    
    describe "by single keywords option" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:keywords => 'github')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 10
        results.people.all.first.first_name.should == 'Giliardi'
        results.people.all.first.last_name.should == 'Pires'
        results.people.all.first.id.should == 'YkdnFl04s_'
      end
    end
    
    describe "by single keywords option with pagination" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:keywords => 'github', :start => 5, :count => 5)
      end
      
      it "should perform a search" do
        results.people.all.size.should == 5
        results.people.all.first.should respond_to(:first_name)
        results.people.all.first.should respond_to(:last_name)
        results.people.all.first.should respond_to(:id)
        results.people.all.last.should respond_to(:first_name)
        results.people.all.last.should respond_to(:last_name)
        results.people.all.last.should respond_to(:id)
      end
    end
    
    describe "by first_name and last_name options" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:first_name => 'Giliardi', :last_name => 'Pires')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 1
        results.people.all.first.first_name.should == 'Giliardi'
        results.people.all.first.last_name.should == 'Pires'
        results.people.all.first.id.should == 'YkdnFl04s_'
      end
    end
    
    describe "by first_name and last_name options with fields" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        fields = [{:people => [:id, :first_name, :last_name, :public_profile_url, :picture_url]}, :num_results]
        client.search(:first_name => 'Giliardi', :last_name => 'Pires', :fields => fields)
      end
      
      it "should perform a search" do
        results.people.all.size.should == 1
        results.people.all.first.first_name.should == 'Giliardi'
        results.people.all.first.last_name.should == 'Pires'
        results.people.all.first.id.should == 'YkdnFl04s_'
        results.people.all.first.picture_url == 'http://media.linkedin.com/mpr/mprx/0_Oz05kn9xkWziAEOUKtOVkqzjXd8Clf7UyqIVkqchR2NtmwZRt1fWoN_aobhg-HmB09jUwPLKrAhU'
        results.people.all.first.public_profile_url == 'http://www.linkedin.com/in/gibanet'
      end
    end
    
    describe "by company_name option" do
      use_vcr_cassette :record => :new_episodes
      
      let(:results) do
        client.search(:company_name => 'linkedin')
      end
      
      it "should perform a search" do
        results.people.all.size.should == 10
        results.people.all.first.first_name.should == 'Donald'
        results.people.all.first.last_name.should == 'Denker'
        results.people.all.first.id.should == 'VQcsz5Hp_h'
      end
    end
    
  end
  
end