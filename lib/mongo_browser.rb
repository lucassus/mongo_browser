require "mongo_browser/version"

require "mongo"
require "json"

module MongoBrowser
  DEFAULT_MONGODB_HOST = "127.0.0.1"
  DEFAULT_MONGODB_PORT = 27017

  class << self
    attr_writer :mongodb_host
    attr_writer :mongodb_port

    def mongodb_host
      @mongodb_host || DEFAULT_MONGODB_HOST
    end

    def mongodb_port
      @mongodb_port || DEFAULT_MONGODB_PORT
    end
  end
end

require "mongo_browser/models/pager"
require "mongo_browser/models/server"
require "mongo_browser/models/database"
require "mongo_browser/models/collection"
require "mongo_browser/models/document"

require "mongo_browser/application"
require "mongo_browser/api"
require "mongo_browser/api/entities"
