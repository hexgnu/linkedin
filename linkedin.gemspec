# -*- encoding: utf-8 -*-
require File.expand_path('../lib/linked_in/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{linkedin}
  s.version  = LinkedIn::VERSION::STRING
  s.platform = Gem::Platform::RUBY

  s.authors = ["Wynn Netherland", "Josh Kalderimis"]
  s.email   = ["wynn.netherland@gmail.com", "josh.kalderimis@gmail.com"]

  s.homepage    = %q{http://github.com/pengwynn/linkedin}
  s.summary     = %q{Ruby wrapper for the LinkedIn API}
  s.description = %q{Ruby wrapper for the LinkedIn API}

  s.date = %q{2010-03-01}

  s.rdoc_options  = ["--charset=UTF-8"]
  s.extra_rdoc_files = ["README.markdown", "changelog.markdown", "LICENSE"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>,         ["~> 0.4.0"])
      s.add_runtime_dependency(%q<hashie>,        ["~> 1.0.0"])
      s.add_runtime_dependency(%q<multi_json>,    ["~> 1.0.0"])
      s.add_development_dependency(%q<yajl-ruby>, ["~> 0.8.0"])
      s.add_development_dependency(%q<rspec>,     ["~> 2.4.0"])
      s.add_development_dependency(%q<rake>,      ["~> 0.8.7"])
      s.add_development_dependency(%q<webmock>,   ["~> 1.6.0"])
      s.add_development_dependency(%q<vcr>,       ["~> 1.6.0"])
    else
      s.add_dependency(%q<oauth>,       ["~> 0.4.0"])
      s.add_dependency(%q<hashie>,      ["~> 1.0.0"])
      s.add_dependency(%q<multi_json>,  ["~> 1.0.0"])
      s.add_dependency(%q<yajl-ruby>,   ["~> 0.8.0"])
      s.add_dependency(%q<rspec>,       ["~> 2.4.0"])
      s.add_dependency(%q<rake>,        ["~> 0.8.7"])
      s.add_dependency(%q<webmock>,     ["~> 1.6.0"])
      s.add_dependency(%q<vcr>,         ["~> 1.6.0"])
    end
  else
    s.add_dependency(%q<oauth>,       ["~> 0.4.0"])
    s.add_dependency(%q<hashie>,      ["~> 1.0.0"])
    s.add_dependency(%q<multi_json>,  ["~> 1.0.0"])
    s.add_dependency(%q<yajl-ruby>,   ["~> 0.8.0"])
    s.add_dependency(%q<rspec>,       ["~> 2.4.0"])
    s.add_dependency(%q<rake>,        ["~> 0.8.7"])
    s.add_dependency(%q<webmock>,     ["~> 1.6.0"])
    s.add_dependency(%q<vcr>,         ["~> 1.6.0"])
  end
end

