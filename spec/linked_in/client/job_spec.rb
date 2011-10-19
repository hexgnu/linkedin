require 'helper'

describe LinkedIn::Client::Company do

  before do
    @client = LinkedIn::Client.new
  end

  describe ".job" do
    it "should return the details of the job based on the id" do
      stub_get("/jobs/1337").
        to_return(:body => fixture("job_description.json"))
      job = @client.job(1337)
      job.company.name.should == "Smart Connections"
    end

    it "should return the details of a job with fields passed" do
      stub_get("/jobs/1337:(id,company,posting-date)").
        to_return(:body => fixture("job_description.json"))
      job = @client.job(1337, :fields => ['id','company','posting-date'])
      job.posting_date.year.should == 2005
    end

  end
end
