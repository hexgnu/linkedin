require 'rubygems'
require 'linkedin'

# get your api keys at https://www.linkedin.com/secure/developer
client = LinkedIn::Client.new('your_consumer_key', 'your_consumer_secret')
rtoken = client.request_token.token
rsecret = client.request_token.secret

# to test from your desktop, open the following url in your browser
# and record the pin it gives you
client.request_token.authorize_url
=> "https://api.linkedin.com/uas/oauth/authorize?oauth_token=<generated_token>"

# then fetch your access keys
client.authorize_from_request(rtoken, rsecret, pin)
=> ["OU812", "8675309"] # <= save these for future requests

# or authorize from previously fetched access keys
c.authorize_from_access("OU812", "8675309")

# you're now free to move about the cabin, call any API method
