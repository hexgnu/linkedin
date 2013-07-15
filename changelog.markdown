# Changelog

## 0.4.0 - May 30, 2013

* Add capability to ask for desired permissions from linked in api
* Add option to specify a proxy
* Bump hashie version
* fix the permission param passing
* fix to be able to pass the permission scope  
* Manipulating comments/likes for network_updates ('shares')
* Methods to work with comments/likes for share  
* Added a method to get a user's shares
* Added current user's shares as an option (client.shares)
* Readme Typos



##  0.2.x - March x, 2010

* Removed Crack as a dependency, Nokogiri FTW

##  0.2.1 - March 1, 2010

* Big dependency clean up, only OAuth and Nokogiri are really needed.

* Use Nokogiri for xml generation (thanks Leonid Shevtsov - leonid-shevtsov)

* Like and Likes supported

* Escape querystring args

* General coding cleanup

* Added Languages, Skills, Publications, Patents and Phone Numbers (thanks Tadas Tamošauskas - medwezys)

* Extra fields added to profile (thanks Tadas Tamošauskas - medwezys)

* public\_profile\_field added to Profile (thanks troysteinbauer)

* Added recommendations (thanks Erol)

* Added current-share

* Added default\_profile\__fields config option

##  0.1.7 - February 5, 2010

* New group join status support JGRP from Terry Ray

##  0.1.6 - January 20, 2010

* Fixed bug with network status update connection collections - thanks Terry Ray

##  0.1.5 - January 13, 2010

* Added education and profile fields missing from updated LinkedIn docs

##  0.1.4 - January 13, 2010

* Applied patch for position end month/year from @holman

##  0.1.3 - December 24, 2009

* Added configure block for easier initialization of consumer token, secret

##  0.1.1 - December 8, 2009

* Applied patch from [nfo](http://github.com/nfo) to fix error handling

## 0.1.0 - November 25, 2009

* Network updates API support

* Search API support

* Updates API support

## 0.0.2 - November 25, 2009

* Swapped out Crack for ROXML for prettier object access

* Added more tests for Profile API

## 0.0.1 - November 24, 2009

* Initial release