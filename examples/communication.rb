# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# send a message to a person in your network. you will need to authenticate the 
# user and ask for the "w_messages" permission.
response = client.send_message("subject", "body", ["person_1_id", "person_2_id"])