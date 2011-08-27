# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# get the profile for the authenticated user
client.profile

#get the profile Job History
LinkedIn.default_profile_fields = ['positions']
client.profile.positions

#get the profile education
LinkedIn.default_profile_fields = ['educations']
client.profile.educations

#or group them together
LinkedIn.default_profile_fields = ['educations', 'positions']
client.profile.positions

# get a profile for someone found in network via ID
client.profile(:id => 'gNma67_AdI')

# get a profile for someone via their public profile url
client.profile(:url => 'http://www.linkedin.com/in/netherland')


