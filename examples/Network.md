# Network

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
