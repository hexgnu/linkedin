# Linkedin Gem Examples

## OAuth 1.0a Authentication

Here's an example of authenticating with the LinkedIn API

```ruby
require 'rubygems'
require 'linkedin'

# get your api keys at https://www.linkedin.com/secure/developer
client = LinkedIn::Client.new('your_consumer_key', 'your_consumer_secret')

# If you want to use one of the scopes from linkedin you have to pass it in at this point
# You can learn more about it here: http://developer.linkedin.com/documents/authentication
request_token = client.request_token({}, :scope => "r_basicprofile+r_emailaddress")

rtoken = request_token.token
rsecret = request_token.secret

# to test from your desktop, open the following url in your browser
# and record the pin it gives you
request_token.authorize_url
=> "https://api.linkedin.com/uas/oauth/authorize?oauth_token=<generated_token>"

# then fetch your access keys
client.authorize_from_request(rtoken, rsecret, pin)
=> ["OU812", "8675309"] # <= save these for future requests

# or authorize from previously fetched access keys
client.authorize_from_access("OU812", "8675309")

# you're now free to move about the cabin, call any API method
```


## Profile

Here are some examples of accessing a user's profile

```ruby
# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# get the profile for the authenticated user
client.profile

# get a profile for someone found in network via ID
client.profile(:id => 'gNma67_AdI')

# get a profile for someone via their public profile url
client.profile(:url => 'http://www.linkedin.com/in/netherland')

# provides the ability to access authenticated user's company field in the profile
user = client.profile(:fields => %w(positions))
companies = user.positions.all.map{|t| t.company}
# Example: most recent company can be accessed via companies[0]

# Example of a multi-email search against the special email search API
account_exists = client.profile(:email => 'email=yy@zz.com,email=xx@yy.com', :fields => ['id'])
```


## Sending a Message

Here's an example of sending a message to two recipients

```ruby
# AUTHENTICATE FIRST found in examples/authenticate.md

# client is a LinkedIn::Client

# send a message to a person in your network. you will need to authenticate the 
# user and ask for the "w_messages" permission.
response = client.send_message("subject", "body", ["person_1_id", "person_2_id"])
```


## User's Network

Here are some examples of accessing network updates and connections of
the authenticated user

``` ruby
# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# get network updates for the authenticated user
client.network_updates

# get profile picture changes
client.network_updates(:type => 'PICT')

# view connections for the currently authenticated user
client.connections
```
# get the original picture-url for one of the connections
client.picture_urls(:id => 'id_of_connection')
# get the image over https instead of http
client.picture_urls(:id => 'id_of_connection', :secure => "true")

## Update User's Status

Here's an example of updating the current user's status

```ruby
# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# update status for the authenticated user
client.add_share(:comment => 'is playing with the LinkedIn Ruby gem')
```


## Sinatra App

Here's an example sinatra application that performs authentication,
after which some info about the authenticated user can be retrieved.

```ruby
require "rubygems"
require "haml"
require "sinatra"
require "linkedin"

enable :sessions

helpers do
  def login?
    !session[:atoken].nil?
  end
  
  def profile
    linkedin_client.profile unless session[:atoken].nil?
  end
  
  def connections
    linkedin_client.connections unless session[:atoken].nil?
  end
  
  private
  def linkedin_client
    client = LinkedIn::Client.new(settings.api, settings.secret)
    client.authorize_from_access(session[:atoken], session[:asecret])
    client
  end 
  
end

configure do
  # get your api keys at https://www.linkedin.com/secure/developer
  set :api, "your_api_key"
  set :secret, "your_secret"
end

get "/" do
  haml :index
end

get "/auth" do
  client = LinkedIn::Client.new(settings.api, settings.secret)
  request_token = client.request_token(:oauth_callback => "http://#{request.host}:#{request.port}/auth/callback")
  session[:rtoken] = request_token.token
  session[:rsecret] = request_token.secret

  redirect client.request_token.authorize_url
end

get "/auth/logout" do
   session[:atoken] = nil
   redirect "/"
end

get "/auth/callback" do
  client = LinkedIn::Client.new(settings.api, settings.secret)
  if session[:atoken].nil?
    pin = params[:oauth_verifier]
    atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
    session[:atoken] = atoken
    session[:asecret] = asecret    
  end
  redirect "/"
end


__END__
@@index
-if login?
  %p Welcome #{profile.first_name}!
  %a{:href => "/auth/logout"} Logout
  %p= profile.headline
  %br
  %div= "You have #{connections.total} connections!"
  -connections.all.each do |c|
    %div= "#{c.first_name} #{c.last_name} - #{c.headline}"
-else
  %a{:href => "/auth"} Login using LinkedIn
```
