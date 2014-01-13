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

