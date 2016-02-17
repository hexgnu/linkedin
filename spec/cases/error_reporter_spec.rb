require 'helper'

describe LinkedIn::Client do
  before do
    LinkedIn.default_profile_fields = nil
    client.stub(:consumer).and_return(consumer)
    client.authorize_from_access('atoken', 'asecret')
  end

  let(:client) { LinkedIn::Client.new('token', 'secret') }
  let(:consumer) { OAuth::Consumer.new('token', 'secret', :site => 'https://api.linkedin.com') }

  it 'raises an unauthorized error when 401' do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}", :status => 401)
    ->{ client.profile }.should raise_error(LinkedIn::Errors::UnauthorizedError)
  end

  it 'raises a general error when 400' do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}", :status => 400)
    ->{ client.profile }.should raise_error(LinkedIn::Errors::GeneralError)
  end

  it 'raises a access denied error when 403' do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}", :status => 403)
    ->{ client.profile }.should raise_error(LinkedIn::Errors::AccessDeniedError)
  end

  it 'raises a notfounderror when 404' do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}", :status => 404)
    ->{ client.profile }.should raise_error(LinkedIn::Errors::NotFoundError)
  end

  it 'raises a informlinkedinerror if 500' do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}", :status => 500)
    ->{ client.profile }.should raise_error(LinkedIn::Errors::InformLinkedInError)
  end

  it 'raises an unavailable error if either 502 or 503' do
    stub_request(:get, "https://api.linkedin.com/v1/people/~").to_return(:body => "{}", :status => 502)
    ->{ client.profile }.should raise_error(LinkedIn::Errors::UnavailableError)
  end
end
