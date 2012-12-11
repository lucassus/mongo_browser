require "mongo_browser/middleware/sprockets_base"

module MongoBrowser
  module Middleware
    class SprocketsSinatra < SprocketsBase
      def initialize(app, options = {})
        @app = app
        @root = options[:root]
        path =  options[:path] || "assets"
        @matcher = /^\/#{path}\/*/
        @environment = ::Sprockets::Environment.new(@root)

        # Application assets
        @environment.append_path "app/assets/javascripts"
        @environment.append_path "app/assets/stylesheets"
        @environment.append_path "app/assets/images"

        # Vendor assets
        @environment.append_path "vendor/assets/javascripts"
        @environment.append_path "vendor/assets/stylesheets"
        @environment.append_path "vendor/assets/images"
      end
    end
  end
end
