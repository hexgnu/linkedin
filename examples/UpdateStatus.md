# Update Status

Here's an example of updating the current user's status

```ruby
# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# update status for the authenticated user
client.add_share(:comment => 'is playing with the LinkedIn Ruby gem')
```
