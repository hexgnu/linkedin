require 'helper'

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

  describe "#search_company" do

    describe "by keywords string parameter" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        client.search('apple', :company)
      end

      it "should perform a company search" do
        results.companies.all.size.should == 10
        results.companies.all.first.name.should == 'Apple'
        results.companies.all.first.id.should == 162479
      end
    end

    describe "by single keywords option" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple'}
        client.search(options, :company)
      end

      it "should perform a company search" do
        results.companies.all.size.should == 10
        results.companies.all.first.name.should == 'Apple'
        results.companies.all.first.id.should == 162479
      end
    end

    describe "by single keywords option with facets to return" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple', :facets => [:industry]}
        client.search(options, :company)
      end

      it "should return a facet" do
        results.facets.all.first.buckets.all.first.name.should == 'Information Technology and Services'
      end
    end

    describe "by single keywords option with pagination" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        options = {:keywords => 'apple', :start => 5, :count => 5}
        client.search(options, :company)
      end

      it "should perform a search" do
        results.companies.all.size.should == 5
        results.companies.all.first.name.should == 'Apple Vacations'
        results.companies.all.first.id.should == 19271
        results.companies.all.last.name.should == 'Micro Center'
        results.companies.all.last.id.should == 15552
      end
    end

    describe "by keywords options with fields" do
      use_vcr_cassette :record => :new_episodes

      let(:results) do
        fields = [{:companies => [:id, :name, :industries, :description, :specialties]}, :num_results]
        client.search({:keywords => 'apple', :fields => fields}, 'company')
      end

      it "should perform a search" do
        results.companies.all.first.name.should == 'Apple'
        results.companies.all.first.description.should == 'Apple designs Macs, the best personal computers in the world, along with Mac OS X, iLife, iWork, and professional software. Apple leads the digital music revolution with its iPods and iTunes online store. Apple is reinventing the mobile phone with its revolutionary iPhone and App Store, and has recently introduced its magical iPad which is defining the future of mobile media and computing devices.'
        results.companies.all.first.id.should == 162479
      end
    end

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
        results.people.all.first.first_name.should == 'Stephen'
        results.people.all.first.last_name.should == 'M.'
        results.people.all.first.id.should == 'z2XMcxa_dR'
        results.people.all.last.first_name.should == 'Pablo'
        results.people.all.last.last_name.should == 'C.'
        results.people.all.last.id.should == 'pdzrGpyP0h'
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

    describe "#field_selector" do
      it "should not modify the parameter object" do
        fields = [{:people => [:id, :first_name]}]
        fields_dup = fields.dup
        client.send(:field_selector, fields)
        fields.should eq fields_dup
      end
    end

  end

end