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

  %w(
    API_KEY
    SECRET_KEY
    OAUTH_USER_TOKEN
    OAUTH_USER_SECRET
  ).each do |var|
    c.filter_sensitive_data("<#{var}>") { ENV[var] }
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

RSpec::Matchers.define :have_attribute do |expected|
  match do |actual|
    actual.respond_to?(expected) && !actual.send(expected).nil?
  end
end
