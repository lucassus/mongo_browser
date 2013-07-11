$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "mongo_browser"
run Rack::URLMap.new \
    "/" => MongoBrowser::Application.new,
    "/api" => MongoBrowser::Api::Mongo.new
