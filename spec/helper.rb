$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'linkedin'
require 'rspec'
require 'webmock/rspec'

def a_delete(url)
  a_request(:delete, linkedin_url(url))
end

def a_get(url)
  a_request(:get, linkedin_url(url))
end

def a_patch(url)
  a_request(:patch, linkedin_url(url))
end

def a_post(url)
  a_request(:post, linkedin_url(url))
end

def a_put(url)
  a_request(:put, linkedin_url(url))
end

def stub_delete(url)
  stub_request(:delete, linkedin_url(url))
end

def stub_get(url)
  stub_request(:get, linkedin_url(url))
end

def stub_patch(url)
  stub_request(:patch, linkedin_url(url))
end

def stub_post(url)
  stub_request(:post, linkedin_url(url))
end

def stub_put(url)
  stub_request(:put, linkedin_url(url))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def linkedin_url(url)
  if url =~ /^http/
    url
  else
    "http://api.linkedin.com#{url}"
  end
end
