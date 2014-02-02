require 'helper'

describe LinkedIn::Api::People do
  use_vcr_cassette record: :new_episodes

  before do
    client.authorize_from_access(ENV['OAUTH_USER_TOKEN'], ENV['OAUTH_USER_SECRET'])
  end

  let(:client) { LinkedIn::Client.new(ENV['API_KEY'], ENV['SECRET_KEY']) }

  describe "#profile" do
    context "with no arguments" do
      subject { client.profile }

      it { should have_attribute :first_name }
      it { should have_attribute :last_name }
      it { should have_attribute :headline }
    end

    context "with a public profile url" do
      subject { client.profile(url: 'http://www.linkedin.com/in/jeffweiner08') }

      its(:first_name) { should eq 'Jeff' }
      its(:last_name) { should eq 'Weiner' }
    end

    context "with a member token" do
      let(:member_token) { client.connections.all[0].id }
      subject { client.profile(id: member_token) }

      its(:first_name) { should eq 'Test' }
      its(:last_name) { should eq 'Accounts2' }
    end
  end

  describe "#connections" do
    context "for current user" do
      subject { client.connections }

      it { should have_attribute :all }
      its(:all) { should have_at_least(1).items }
    end
  end

  describe "#new_connections" do
    context "for current user" do
      let(:modified_since) { Date.parse('2014/02/02').to_time.to_i * 1000 }
      subject { client.new_connections(modified_since) }

      it { should have_attribute :all }
      its(:all) { should have(0).items }
    end
  end
end
