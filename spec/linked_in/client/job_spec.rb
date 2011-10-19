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

  describe ".job_bookmarks" do
    it "should return the job bookmarks for the current user" do
      stub_get("/people/~/job-bookmarks").
        to_return(:body => fixture("job_bookmarks.json"))
      bookmark = @client.job_bookmarks
      bookmark._total.should == 3
    end
  end

  describe ".job_suggestions" do
    it "should return a list of suggested jobs" do
      stub_get("/people/~/suggestions/job-suggestions:(jobs)").
        to_return(:body => fixture("job_suggestions.json"))
      suggestions = @client.job_suggestions
      suggestions.jobs._total.should == 50
    end
  end

  describe ".job_search" do
    it "should return a list of jobs" do
      stub_get("/job-search").
        to_return(:body => fixture("job_search.json"))
      search = @client.job_search
      search.jobs._total.should == 82792
    end

    it "should return a list of jobs when passing a keyword" do
      stub_get("/job-search?keywords=ruby").
        to_return(:body => fixture("job_search_ruby.json"))
      search = @client.job_search(:keywords => "ruby")
      search.num_results.should == 1047
    end

  end

end
