require 'helper'

describe LinkedIn do

  before(:each) do
    LinkedIn.token = nil
    LinkedIn.secret = nil
    LinkedIn.default_profile_fields = nil
  end

  it "should be able to set the consumer token and consumer secret" do
    LinkedIn.token  = 'consumer_token'
    LinkedIn.secret = 'consumer_secret'

    LinkedIn.token.should  == 'consumer_token'
    LinkedIn.secret.should == 'consumer_secret'
  end

  it "should be able to set the default profile fields" do
    LinkedIn.default_profile_fields = ['education', 'positions']

    LinkedIn.default_profile_fields.should == ['education', 'positions']
  end

  it "should be able to set the consumer token and consumer secret via a configure block" do
    LinkedIn.configure do |config|
      config.token  = 'consumer_token'
      config.secret = 'consumer_secret'
      config.default_profile_fields = ['education', 'positions']
    end

    LinkedIn.token.should  == 'consumer_token'
    LinkedIn.secret.should == 'consumer_secret'
    LinkedIn.default_profile_fields.should == ['education', 'positions']
  end

end
