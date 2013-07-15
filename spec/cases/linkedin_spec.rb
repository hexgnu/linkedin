require 'helper'

describe LinkedIn do

  before(:each) do
    LinkedIn.client_id = nil
    LinkedIn.client_secret = nil
    LinkedIn.default_profile_fields = nil
  end

  it "should be able to set the client_id and client_secret" do
    LinkedIn.client_id  = 'client_id'
    LinkedIn.client_secret = 'client_secret'

    LinkedIn.client_id.should  == 'client_id'
    LinkedIn.client_secret.should == 'client_secret'
  end

  it "should be able to set the default profile fields" do
    LinkedIn.default_profile_fields = ['education', 'positions']

    LinkedIn.default_profile_fields.should == ['education', 'positions']
  end

  it "should be able to set the client_id and client_secret via a configure block" do
    LinkedIn.configure do |config|
      config.client_id  = 'client_id'
      config.client_secret = 'client_secret'
      config.default_profile_fields = ['education', 'positions']
    end

    LinkedIn.client_id.should  == 'client_id'
    LinkedIn.client_secret.should == 'client_secret'
    LinkedIn.default_profile_fields.should == ['education', 'positions']
  end

end
