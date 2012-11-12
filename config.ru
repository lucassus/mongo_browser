$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "mongo_browser"
run MongoBrowser::Application
