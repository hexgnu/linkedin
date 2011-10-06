require 'helper'

describe LinkedIn do

  describe "Client.new" do
    it "should be a LinkedIn::Client" do
      LinkedIn::Client.new.should be_a LinkedIn::Client
    end
  end

end

