# LinkedIn

Oauth 2.0 Ruby wrapper for the [LinkedIn API](http://developer.linkedin.com). Designed to drop into [pengwynn/linkedin](https://github.com/pengwynn/linkedin)'s Oauth 1.0 Linkedin API interface. Also heavily inspired by [John Nunemaker's](http://github.com/jnunemaker) [Twitter gem](http://github.com/jnunemaker/twitter)

Travis CI : [![Build Status](https://secure.travis-ci.org/emorikawa/linkedin-oauth2.png)](http://travis-ci.org/emorikawa/linkedin-oauth2)

## Installation

    [sudo] gem install linkedin-oauth2

## Usage

### Authenticate

LinkedIn's API uses OAuth 2.0 for authentication. Luckily, this gem hides most of the gory details from you.

The gory details can be found [here](https://developer.linkedin.com/documents/authentication)

For legacy support of LinkedIn's OAuth 1.0a api, refer to the [pengwynn/linkedin](https://github.com/pengwynn/linkedin) gem.

```ruby
require 'rubygems'
require 'linkedin-oauth2'

# get your api keys at https://www.linkedin.com/secure/developer
client = LinkedIn::Client.new('your_client_id', 'your_client_secret')
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
client.authorize_from_access("OU812", "8675309")

# you're now free to move about the cabin, call any API method
```

### Profile examples
```ruby
# get the profile for the authenticated user
client.profile

# get a profile for someone found in network via ID
client.profile(:id => 'gNma67_AdI')

# get a profile for someone via their public profile url
client.profile(:url => 'http://www.linkedin.com/in/netherland')
```


More examples in the [examples folder](http://github.com/pengwynn/linkedin/blob/master/examples).

For a nice example on using this in a [Rails App](http://pivotallabs.com/users/will/blog/articles/1096-linkedin-gem-for-a-web-app).

If you want to play with the LinkedIn api without using the gem, have a look at the [apigee LinkedIn console](http://app.apigee.com/console/linkedin).

## Migration from OAuth 1.0a to OAuth 2.0
* The terms `token`, `consumer token`, or `consumer key` in OAuth 1.0 are now referred to as **`client_id`** in OAuth 2.0
* The terms `secret`, or `consumer secret` in OAuth 1.0 are now referred to as **`client_secret`** in OAuth 2.0
* In OAuth 1.0 there is both an `auth token` and an `auth secret`. OAuth 2.0 combines these into a single `access token`.
* The terms `auth token`, `auth key`, `auth secret`, `access secret`, `access token`, or `access key` have all been collapsed and are now referred to as the **`access token`**.


## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Testing
Run `bundle install`

## Copyright

Copyright (c) 2013 [Evan Morikawa](https://twitter.com/E0M). See LICENSE for details.
