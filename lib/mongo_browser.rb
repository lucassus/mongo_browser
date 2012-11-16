require "mongo_browser/version"

require "sinatra"
require "sprockets"
require "sass"
require "coffee_script"

require "mongo"
require "json"
require "ap"

module MongoBrowser
  class << self
    attr_writer :mongodb_host
    attr_writer :mongodb_port

    def mongodb_host
      @mongodb_host || "localhost"
    end

    def mongodb_port
      @mongodb_port || 27017
    end
  end
end

require "mongo_browser/sprockets_sinatra_middleware"
require "mongo_browser/application"
