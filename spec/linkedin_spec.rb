require 'helper'

describe LinkedIn do
  after do
    LinkedIn.reset
  end

  context "when delegating to a client" do
    describe '.respond_to?' do
      it "should take an optional argument" do
        LinkedIn.respond_to?(:new, true).should be_true
      end
    end

    describe ".new" do
      it "should be a LinkedIn::Client" do
        LinkedIn.new.should be_a LinkedIn::Client
      end
    end

    describe ".configure" do
      LinkedIn::Configuration::VALID_OPTIONS_KEYS.each do |key|
        it "should set the #{key}" do
          LinkedIn.configure do |config|
            config.send("#{key}=", key)
            LinkedIn.send(key).should == key
          end
        end
      end
    end
  end
end

