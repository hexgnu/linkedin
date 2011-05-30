require 'webmock/rspec'
require 'vcr'

require 'linkedin'


VCR.config do |c|
  c.cassette_library_dir     = 'spec/fixtures/cassette_library'
  c.stub_with                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
  
  # do not save request and authorization headers
  c.before_record do |i|
    i.request.headers = nil
  end
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end


def linkedin_url(url)
  url =~ /^http/ ? url : "https://api.linkedin.com#{url}"
end


def expect_post(url, body, result = nil)
  a_request(:post, linkedin_url(url)).with({
    :body => fixture(body).read,
    :headers => { :content_type => 'application/xml' }
  }).should have_been_made.once
end


# def stub_put(url, returns_xml, status=nil)
#   options = { :body => fixture(returns_xml) }
#   options.merge!({ :status => status }) unless status.nil?
#   stub_request(:put, linkedin_url(url)).to_return(options)
# end
#
# def stub_delete(url, returns_xml)
#   stub_request(:delete, linkedin_url(url)).to_return(:body => fixture(returns_xml))
# end
