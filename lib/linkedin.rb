require 'forwardable'
require 'rubygems'

gem 'oauth', '~> 0.3.5'
require 'oauth'

gem 'hashie', '~> 0.1.3'
require 'hashie'

gem 'crack', '~> 0.1.4'
require 'crack'

require 'cgi'

directory = File.expand_path(File.dirname(__FILE__))

require File.join(directory, 'linked_in', 'client')