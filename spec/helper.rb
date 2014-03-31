$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
if ENV['COVERAGE'] == 't'
  require 'simplecov'
  SimpleCov.start
end

require 'linkedin'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/fixtures/cassette_library'
  c.hook_into                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
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
