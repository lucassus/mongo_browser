require "mongo_browser/middleware/sprockets_base"

module MongoBrowser
  module Middleware
    class SprocketsSpecs < SprocketsBase
      def initialize(app, options = {})
        @app = app
        @root = options[:root]
        path =  options[:path] || "_specs"
        @matcher = /^\/#{path}\/*/
        @environment = ::Sprockets::Environment.new(@root)

        # Serve specs
        @environment.append_path "spec/javascripts"
      end
    end
  end
end
