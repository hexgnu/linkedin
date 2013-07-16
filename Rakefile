#!/usr/bin/env rake

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

task :compile_and_test do
  puts "Compiling"
  puts `gem build linkedin-oauth2.gemspec && gem install ./linkedin-oauth2*.gem`
  puts "Testing"
  Rake::Task["test"].invoke
end

require 'rdoc/task'
require File.expand_path('../lib/linked_in/version', __FILE__)
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "linkedin #{LinkedIn::VERSION::STRING}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
