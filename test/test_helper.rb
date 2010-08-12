require 'test/unit'
require 'pathname'

require 'mocha'
require 'shoulda'
require 'fakeweb'
require 'matchy'

require 'linkedin'

FakeWeb.allow_net_connect = false

def stub_get(url, filename, status=nil)
  options = { :body => fixture_file(filename) }
  options.merge!({ :status => status }) if status

  register_fakeweb_uri(:get, url, options)
end

def stub_post(url, filename)
  register_fakeweb_uri(:post, url, :body => fixture_file(filename))
end

def stub_put(url, filename)
  register_fakeweb_uri(:put, url, :body => fixture_file(filename))
end

def stub_delete(url, filename)
  register_fakeweb_uri(:delete, url, :body => fixture_file(filename))
end

def register_fakeweb_uri(method, url, options = {})
  FakeWeb.register_uri(method, linkedin_url(url), options)
end

def linkedin_url(url)
  url =~ /^http/ ? url : "https://api.linkedin.com#{url}"
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end