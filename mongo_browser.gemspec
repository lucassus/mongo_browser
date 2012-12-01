# -*- encoding: utf-8 -*-
require File.expand_path("../lib/mongo_browser/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lukasz Bandzarewicz"]
  gem.email         = ["lucassus@gmail.com"]
  gem.description   = %q{Simple but powerful tool for managing mongodb databases}
  gem.summary       = %q{Web-based application for managing mongodb databases}
  gem.homepage      = "https://github.com/lucassus/mongo_browser"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mongo_browser"
  gem.require_paths = ["lib"]
  gem.version       = MongoBrowser::VERSION

  gem.add_development_dependency("rdoc", "~> 3.12")
  gem.add_development_dependency("aruba", "~> 0.5.1")
  gem.add_development_dependency("rake", "~> 10.0.2")

  gem.add_development_dependency("thin", "~> 1.5.0")
  gem.add_development_dependency("rspec", "~> 2.12.0")
  gem.add_development_dependency("capybara", "~> 1.1.3")
  gem.add_development_dependency("capybara-webkit", "~> 0.13.0")
  gem.add_development_dependency("launchy", "~> 2.1.2")
  gem.add_development_dependency("simplecov", "~> 0.7.1")
  gem.add_development_dependency("debugger", "~> 1.2.2")

  gem.add_dependency("mongo", "~> 1.8.0")
  gem.add_dependency("bson_ext", "~> 1.8.0")
  gem.add_dependency("methadone", "~> 1.2.2")
  gem.add_dependency("foreverb", "~> 0.3.2")
  gem.add_dependency("awesome_print", "~> 1.1.0")

  gem.add_dependency("sinatra", "~> 1.3.3")
  gem.add_dependency("sinatra-contrib", "~> 1.3.2")
  gem.add_dependency("sinatra-flash", "~> 0.3.0")
  gem.add_dependency("will_paginate-bootstrap", "~> 0.2.1")
  gem.add_dependency("json", "~> 1.7.5")

  gem.add_dependency("sprockets", "~> 2.8.1")
  gem.add_dependency("coffee-script", "~> 2.2.0")
  gem.add_dependency("sass", "~> 3.2.3")
end
