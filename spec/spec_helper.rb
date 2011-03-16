begin
  require 'bundler/setup'
rescue LoadError
  puts 'although not required, bundler is recommened for running the tests'
end

require 'webmock/rspec'

require 'client_shared_examples'

require 'linkedin'



def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end


def linkedin_url(url)
  url =~ /^http/ ? url : "https://api.linkedin.com#{url}"
end


def stub_get(url, filename, status=nil)
  options = { :body => fixture(filename) }
  options.merge!({ :status => status }) if status

  stub_request(:get, linkedin_url(url)).to_return(options)
end

def stub_post(url, result)
  result_hash = { :status => 201 }
  result_hash[:body] = fixture(result) if result

  stub_request(:post, linkedin_url(url)).to_return(result_hash)
end

def expect_post(url, body, result = nil)
  a_request(:post, linkedin_url(url)).with({
    :body => fixture(body).read,
    :headers => { :content_type => 'application/xml' }
  }).should have_been_made.once
end

def stub_put(url, returns_xml, status=nil)
  options = { :body => fixture(returns_xml) }
  options.merge!({ :status => status }) if status
  stub_request(:put, linkedin_url(url)).to_return(options)
end

def stub_delete(url, returns_xml)
  stub_request(:delete, linkedin_url(url)).to_return(:body => fixture(returns_xml))
end
