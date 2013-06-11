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

  gem.add_development_dependency("rdoc", "4.0.1")
  gem.add_development_dependency("rake", "10.0.4")

  gem.add_development_dependency("foreman", "0.63.0")
  gem.add_development_dependency("thin", "1.5.1")
  gem.add_development_dependency("rspec", "2.13.0")
  gem.add_development_dependency("rack-test", "0.6.2")
  gem.add_development_dependency("simplecov", "0.7.1")
  gem.add_development_dependency("debugger", "1.6.0")

  gem.add_dependency("mongo", "1.8.6")
  gem.add_dependency("bson_ext", "1.8.6")
  gem.add_dependency("vegas", "0.1.11")

  gem.add_dependency("sinatra", "1.4.3")
  gem.add_dependency("sinatra-contrib", "1.4.0")
  gem.add_dependency("grape", "0.4.1")
  gem.add_dependency("grape-entity", "0.3.0")

  gem.add_dependency("sprockets", "2.10.0")
  gem.add_dependency("coffee-script", "2.2.0")
  gem.add_dependency("sass", "3.2.9")
end
