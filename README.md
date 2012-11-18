# MongoBrowser

[![Build status](https://secure.travis-ci.org/lucassus/mongo_browser.png)](http://travis-ci.org/lucassus/mongo_browser)
[![Dependency Status](https://gemnasium.com/lucassus/mongo_browser.png)](http://gemnasium.com/lucassus/mongo_browser)

Simple but powerful tool for managing mongodb databases

Install the gem:

    $ gem install mongo_browser

## Usage

Run the application

    $ mongo_browser

Run the application as daemon

    $ mongo_browser --demonize

Application will be available by default at http://localhost:4567
In order to run it on custom port number pass the `--port` option with selected port.

Other options are:

    $ mongo_browser --help
    [17/11 16:10:06] Usage: mongo_browser [options]

    v0.1.0

    Options:
            --version                    Show help/version info
            --port PORT                  MongoBrowser port
                                         (Default: 4567)
            --mongodb-host HOST          Mongodb database host
                                         (Default: localhost)
            --mongodb-port PORT          Mongodb database port
                                         (Default: 27017)
            --demonize                   Run the app in the background
            --log-level LEVEL            Set the logging level
                                         (debug|info|warn|error|fatal)
                                         (Default: info)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
