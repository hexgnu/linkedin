require 'spec_helper'

describe LinkedIn::Client do
  context "when hitting the LinkedIn API" do
    before(:each) do
      LinkedIn.token = nil
      LinkedIn.secret = nil
      LinkedIn.default_profile_fields = nil
    end

    let(:client) do
      client = LinkedIn::Client.new('token', 'secret')
      consumer = OAuth::Consumer.new('token', 'secret', {:site => 'https://api.linkedin.com'})
      client.stub(:consumer).and_return(consumer)
      client.authorize_from_access('atoken', 'asecret')
      client
    end

    context "when the response is a 403" do
      before { stub_get("/v1/people/~", "403.xml", 403) }

      it "should raise that error correctly" do
        expect { client.profile }.to raise_error(LinkedIn::Forbidden, "(403): Throttle limit for calls to this resource is reached. - 0") do |e|
          e.data.message.should == "Throttle limit for calls to this resource is reached."
        end
      end
    end

    context "when the response is a 404" do
      before { stub_get("/v1/people/~", "404.xml", 404) }

      it "should raise that error correctly" do
        expect { client.profile }.to raise_error(LinkedIn::NotFound, "(404): Could not find person based on: ~~ - 11") do |e|
          e.data.message.should == "Could not find person based on: ~~"
        end
      end
    end

    describe "#profile" do
      context "for the currently authenticated user" do
        context "with all profile fields" do
          before { stub_get("/v1/people/~", "profile_full.xml") }
          let(:profile) { client.profile }

          it_should_behave_like "a full profile fetch"
        end

        context "with field selection" do
          it "should accept field selectors when retrieving a profile" do
            stub_get("/v1/people/~:(first-name,last-name)", "profile.xml")

            profile = client.profile(:fields => [:first_name, :last_name])
            profile.first_name.should == 'Wynn'
            profile.last_name.should == 'Netherland'
          end
        end

        describe "#connections" do
          it "should retrieve connections for the authenticated user" do
            stub_get("/v1/people/~/connections", "connections.xml")

            cons = client.connections
            cons.size.should == 146
            cons.last.last_name.should == 'Yuchnewicz'
          end
        end
      end

      context "by id" do
        before { stub_get("/v1/people/id=gNma67_AdI", "profile_full.xml") }
        let(:profile) { client.profile(:id => "gNma67_AdI") }

        it_should_behave_like "a full profile fetch"
      end

      context "by url" do
        before { stub_get("/v1/people/url=http%3A%2F%2Fwww.linkedin.com%2Fin%2Fnetherland", "profile_full.xml") }
        let(:profile) { client.profile(:url => "http://www.linkedin.com/in/netherland") }

        it_should_behave_like "a full profile fetch"
      end
    end

    describe "#search" do
      context "by single keyword" do
        it "should perform a search" do
          stub_get("/v1/people-search?keywords=github", "search.xml")

          results = client.search(:keywords => 'github')
          results.start.should == 0
          results.count.should == 20
          results.profiles.first.first_name.should == 'Marcello'
          results.profiles.first.last_name.should  == 'Barnaba'
        end
      end

      context "by multiple keywords" do
        it "should perform a search" do
          stub_get("/v1/people-search?keywords=ruby+rails", "search.xml")

          results = client.search(:keywords => ["ruby", "rails"])
          results.start.should == 0
          results.count.should == 20
          results.profiles.first.first_name.should == 'Marcello'
          results.profiles.first.last_name.should  == 'Barnaba'
        end
      end

      context "by name" do
        it "should perform a search" do
          stub_get("/v1/people-search?name=Zach+Inglis", "search.xml")

          results = client.search(:name => "Zach Inglis")
          results.start.should == 0
          results.count.should == 20
          results.profiles.first.first_name.should == 'Marcello'
          results.profiles.first.last_name.should  == 'Barnaba'
        end
      end

      context "with fields" do
        it "should perform a search" do
          stub_get("/v1/people-search:(people:(first-name,last-name,picture-url))?keywords=github", "search.xml")

          results = client.search(:keywords => 'github', :fields => [:people => ['first-name', 'last-name', 'picture-url']])
          results.start.should == 0
          results.count.should == 20
          results.profiles.first.first_name.should == 'Marcello'
          results.profiles.first.last_name.should  == 'Barnaba'
          results.profiles.first.picture_url.should  == 'http://media.linkedin.com/mpr/mprx/0_izp7Yx1lUA36P3P3_vjpYj1AB1cnACP3TqHrYjtTe9iQa6kT712_rg67MgBWt5tDG9Olls29eWb-'
        end
      end
    end

    describe "#update_status" do
      it "should update a user's current status" do
        stub_put("/v1/people/~/current-status", "blank.xml")

        client.update_status("Testing out the LinkedIn API").code.should == "200"
      end
    end

    describe "#update_network" do
      it "should post to a user's network stream" do
        stub_post("/v1/people/~/person-activities", "blank.xml")

        client.update_network("Testing out the LinkedIn API").code.should == "201"
      end
    end

    describe "#clear_status" do
      it "should clear a user's current status" do
        stub_delete("/v1/people/~/current-status", "blank.xml")

        client.clear_status.should == "200"
      end
    end

    describe "#current_status" do
      it "should retrieve the authenticated user's current status" do
        stub_get("/v1/people/~/current-status", "status.xml")

        client.current_status.should == "New blog post: What makes a good API wrapper? http://wynnnetherland.com/2009/11/what-makes-a-good-api-wrapper/"
      end
    end

    describe "#network_statuses" do
      it "should retrieve status updates for the authenticated user's network" do
        stub_get("/v1/people/~/network?type=STAT", "network_statuses.xml")

        stats = client.network_statuses
        stats.updates.first.timestamp.should == 1259179809524
        stats.updates.first.should be_is_commentable
        stats.updates.first.profile.id.should == "19408512"
        stats.updates.first.profile.first_name.should == 'Vahid'
        stats.updates.first.profile.connections.first.id.should == "28072758"
        stats.updates.first.profile.connections.first.last_name.should == 'Varone'
        stats.updates.first.likes.size.should == 2
        stats.updates.first.likes.last.profile.first_name.should == 'Napoleon'
        stats.updates.last.likes.should be_empty
      end
    end

    describe "#network_updates" do
      it "should retrieve network updates" do
        stub_get("/v1/people/~/network?type=PICT", "picture_updates.xml")

        stats = client.network_updates(:type => "PICT")
        stats.updates.size.should == 4
        stats.updates.last.profile.headline.should == "Creative Director for Intridea"
      end
    end

    describe "#send_message" do
      it "should send a message to recipients" do
        stub_post("/v1/people/~/mailbox", "mailbox_items.xml")

        recipients = ["~", "abcdefg"]
        subject    = "Congratulations on your new position."
        body       = "You're certainly the best person for the job!"

        client.send_message(subject, body, recipients).should == "201"

        expect_post("/v1/people/~/mailbox", "mailbox_items.xml")
      end
    end

    describe "#share" do
      it "should share a link" do
        stub_post("/v1/people/~/shares", "blank.xml")

        client.share({
          :comment => "Testing out the LinkedIn API",
          :title => "Share",
          :url => "http://www.linkedin.com",
          :image_url => "http://www.linkedin.com/pretty_logo.jpg"
        }).code.should == "201"

        expect_post("/v1/people/~/shares", "shares.xml")
      end
    end

    describe "#likes" do
      it "should retrieve likes for a network update" do
        stub_get("/v1/people/~/network/updates/key=gNma67_AdI/likes","likes.xml")

        likes = client.likes("gNma67_AdI")
        likes.size.should == 2
        likes.first.profile.first_name.should == "George"
      end
    end

    describe "#like" do
      it "should put a like to a network update" do
        stub_put("/v1/people/~/network/updates/key=gNma67_AdI/is-liked","blank.xml", 201)

        result = client.like("gNma67_AdI")
        result.code.should == "201"
      end
    end

  end
end
