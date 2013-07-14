# MongoBrowser

[![Build status](https://secure.travis-ci.org/lucassus/mongo_browser.png)](http://travis-ci.org/lucassus/mongo_browser)
[![Coverage Status](https://coveralls.io/repos/lucassus/mongo_browser/badge.png?branch=master)](https://coveralls.io/r/lucassus/mongo_browser)
[![Dependency Status](https://gemnasium.com/lucassus/mongo_browser.png)](http://gemnasium.com/lucassus/mongo_browser)
[![Gem Version](https://badge.fury.io/rb/mongo_browser.png)](http://badge.fury.io/rb/mongo_browser)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/lucassus/mongo_browser)

Simple but powerful tool for managing mongodb databases

Install the gem:

    gem install mongo_browser

## Usage

Run the application

    mongo_browser start

Application will be available by default at http://localhost:5678
In order to run it on custom port number pass the `--port` option with selected port.

## Getting started with the development

```
bundle install
sudo npm install -g grunt grunt-cli karma
```

The main goal of this project is to achieve the highest testability with 100% code coverage. 

In order to execute rspec scenarios for backend just execute:

    rspec spec

### Running frontend specs

#### Inside the console

* `./script/ci_javascript` will execute jasmine specs
* `./script/ci_e2e` will execute angularjs e2e scenarios

#### Inside the browser

Run thin in the test environment:

     thin start -R config.ru -e test -p 3001

or
     foreman start

Navigate to the one of the following url:

* [http://localhost:3001/jasmine](http://localhost:3001/jasmine) will execute jasmine specs
* [http://localhost:3001/e2e](http://localhost:3001/e2e) will execute angularjs e2e scenarios

### Continuous integration

All specs (backend + frontend) could be executed with the following command `./script/ci_all`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
