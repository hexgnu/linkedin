$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'linkedin'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir     = 'spec/fixtures/cassette_library'
  c.stub_with                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
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
