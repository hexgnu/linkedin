require 'helper'

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
        'id' => 1345,
        '_total' => 1234,
        'values' => {},
        'numResults' => 'total_results'
      })
    end

    it "should convert camal cased hash keys to underscores" do
      mash.should have_key('first_name')
      mash.should have_key('last_name')
    end

    # this breaks data coming back from linkedIn
    it "converts _key to id if there is an id column" do
      mash._key.should == 1234
      mash.id.should == 1345
    end

    context 'no collision' do
      let(:mash) {
        LinkedIn::Mash.new({
          '_key' => 1234
        })

      }
      it 'converts _key to id if there is no collision' do
        mash.id.should == 1234
        mash._key.should == 1234
      end
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
      time_mash = LinkedIn::Mash.new({ 'timestamp' => 1297083249 })

      time_mash.timestamp.should be_a_kind_of(Time)
      time_mash.timestamp.to_i.should  == 1297083249
    end

    it "should return a valid Time if a key of timestamp exists and the value is an int which is greater than 9999999999" do
      time_mash = LinkedIn::Mash.new({ 'timestamp' => 1297083249 * 1000 })

      time_mash.timestamp.should be_a_kind_of(Time)
      time_mash.timestamp.to_i.should  == 1297083249
    end

    it "should not try to convert to a Time object if the value isn't an Integer" do
      time_mash = LinkedIn::Mash.new({ 'timestamp' => 'Foo' })

      time_mash.timestamp.class.should be String
    end
  end

  describe "#to_date" do
    let(:date_mash) do
      LinkedIn::Mash.new({
        'year' => 2010,
        'month' => 06,
        'day' => 23
      })
    end

    it "should return a valid Date if the keys year, month, day all exist" do
      date_mash.to_date.should == Date.civil(2010, 06, 23)
    end
  end

  describe "#all" do
    let(:all_mash) do
      LinkedIn::Mash.new({
        :values => nil
      })
    end

    it "should return an empty array if values is nil due to no results being found for a query" do
      all_mash.all.should == []
    end
  end

end
