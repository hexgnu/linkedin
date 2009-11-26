# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# get the profile for the authenticated user
client.profile

# get a profile for someone found in network via ID
client.profile(:id => 'gNma67_AdI')

# get a profile for someone via their public profile url
client.profile(:url => 'http://www.linkedin.com/in/netherland')


