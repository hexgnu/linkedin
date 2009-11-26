# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# update status for the authenticated user
client.update_status('is playing with the LinkedIn Ruby gem')

# clear status for the currently logged in user
client.clear_status
