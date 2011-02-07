require 'spec_helper'

describe LinkedIn::Mash do

  describe ".from_json" do
    it "should convert a json string to a Mash" do
      json_string = "{\"name\":\"Josh Kalderimis\"}"
      mash = LinkedIn::Mash.from_json(json_string)
      
      mash.should have_key('name')
      mash.name.should == 'Josh Kalderimis'
    end
  end
  
  describe "#convert_keys" do
    let(:mash) do
      LinkedIn::Mash.new({ 
        'firstName' => 'Josh',
        'LastName' => 'Kalderimis',
        '_key' => 1234,
        '_total' => 1234,
        'values' => {},
        'numResults' => 'total_results'
      })
    end
    
    it "should convert camal cased hash keys to underscores" do
      mash.should have_key('first_name')
      mash.should have_key('last_name')
    end
    
    it "should convert the key _key to id" do
      mash.should have_key('id')
    end
    
    it "should convert the key _total to total" do
      mash.should have_key('total')
    end
    
    it "should convert the key values to all" do
      mash.should have_key('all')
    end
    
    it "should convert the key numResults to total_results" do
      mash.should have_key('total_results')
    end
  end
  
  describe '#timestamp' do
    it "should return a valid Time if a key of timestamp exists and the value is an int" do
      timestamp = Time.now
    
      time = {
        'timestamp' => timestamp.to_i
      }
    
      time_mash = LinkedIn::Mash.new(time)
    
      time_mash.timestamp.class.should be Time
      timestamp.to_i.should == time_mash.timestamp.to_i
    end

    it "should return a valid Time if a key of timestamp exists and the value is an int which is greater than 9999999999" do
      timestamp = Time.now
    
      time = {
        'timestamp' => timestamp.to_i * 1000
      }
    
      time_mash = LinkedIn::Mash.new(time)
    
      time_mash.timestamp.class.should be Time
      timestamp.to_i.should == time_mash.timestamp.to_i
    end
    
    it "should not try to convert to a Time object if the value isn't an Integer" do
      time = {
        'timestamp' => 'Foo'
      }
    
      time_mash = LinkedIn::Mash.new(time)
    
      time_mash.timestamp.class.should be String
    end
  end
  
  describe "#to_date" do
    it "should return a valid Date if the keys year, month, day all exist" do
      date = {
        'year' => 2010,
        'month' => 06,
        'day' => 23
      }
    
      date_mash = LinkedIn::Mash.new(date)
    
      date_mash.to_date.should == Date.civil(2010, 06, 23)
    end
  end
  
end