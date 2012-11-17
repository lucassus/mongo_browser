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

  gem.add_development_dependency("rdoc")
  gem.add_development_dependency("aruba")
  gem.add_development_dependency("rake", "~> 0.9.2")

  gem.add_dependency("mongo", "~> 1.7.0")
  gem.add_dependency("bson_ext", "~> 1.7.0")
  gem.add_dependency("methadone", "~> 1.2.2")
  gem.add_dependency("foreverb", "~> 0.3.2")
  gem.add_dependency("sinatra", "~> 1.3.3")
  gem.add_dependency("sinatra-contrib", "~> 1.3.2")
  gem.add_dependency("sinatra-flash", "~> 0.3.0")
  gem.add_dependency("will_paginate-bootstrap", "~> 0.2.1")
  gem.add_dependency("json", "~> 1.7.5")
  gem.add_dependency("awesome_print", "~> 1.1.0")
end
