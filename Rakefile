#!/usr/bin/env rake

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec
load 'vcr/tasks/vcr.rake'

require File.expand_path('../lib/linked_in/version', __FILE__)
require 'yard'
YARD::Rake::YardocTask.new
