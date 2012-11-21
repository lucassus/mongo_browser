require "mongo_browser/version"

require "sinatra"
require "sinatra/reloader"
require "sinatra/flash"

require "sprockets"
require "sass"
require "coffee_script"

require "will_paginate-bootstrap"
require "mongo"
require "json"
require "ap"

module MongoBrowser
  DEFAULT_HOST = "127.0.0.1"
  DEFAULT_PORT = 27017

  class << self
    attr_writer :mongodb_host
    attr_writer :mongodb_port

    def mongodb_host
      @mongodb_host || DEFAULT_HOST
    end

    def mongodb_port
      @mongodb_port || DEFAULT_PORT
    end
  end
end

require "mongo_browser/middleware/sprockets_sinatra"
require "mongo_browser/application"
