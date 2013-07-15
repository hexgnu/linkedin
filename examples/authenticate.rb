require 'rubygems'
require 'linkedin'

# get your api keys at https://www.linkedin.com/secure/developer
client = LinkedIn::Client.new('your_client_id', 'your_client_secret')

# Get a url that you can enter into the browser to connect a user's
# account to your client_id and client_secret.
authorize_url = client.authorize_url

# Record the 'code' param (check the url bar) then use it to request the
# access_token.
access_token = client.get_token("<auth_code from last step>")

# Once you've initialized the access_token, you can call any api method
client.profile
