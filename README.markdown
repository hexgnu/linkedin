# LinkedIn

Ruby wrapper for the [LinkedIn API](http://developer.linkedin.com). Heavily inspired by [John Nunemaker's](http://github.com/jnunemaker) [Twitter gem](http://github.com/jnunemaker/twitter), the LinkedIn gem provides an easy-to-use wrapper for LinkedIn's Oauth/XML APIs.

Travis CI : [![Build Status](https://secure.travis-ci.org/pengwynn/linkedin.png)](http://travis-ci.org/pengwynn/linkedin)

## Installation

    [sudo] gem install linkedin

## Usage

### Authenticate

LinkedIn's API uses Oauth for authentication. Luckily, the LinkedIn gem hides most of the gory details from you.

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

### Profile examples

    # get the profile for the authenticated user
    client.profile

    # get a profile for someone found in network via ID
    client.profile(:id => 'gNma67_AdI')

    # get a profile for someone via their public profile url
    client.profile(:url => 'http://www.linkedin.com/in/netherland')



More examples in the [examples folder](http://github.com/pengwynn/linkedin/blob/master/examples).

For a nice example on using this in a [Rails App](http://pivotallabs.com/users/will/blog/articles/1096-linkedin-gem-for-a-web-app).

If you want to play with the LinkedIn api without using the gem, have a look at the [apigee LinkedIn console](http://app.apigee.com/console/linkedin).

## TODO

* Change to json api
* Update and correct test suite
* Change to Faraday for authentication
* Implement Messaging APIs

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009-11 [Wynn Netherland](http://wynnnetherland.com). See LICENSE for details.
