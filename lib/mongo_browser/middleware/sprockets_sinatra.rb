module MongoBrowser
  module Middleware
    class SprocketsSinatra
      def initialize(app, options = {})
        @app = app
        @root = options[:root]
        path =  options[:path] || "assets"
        @matcher = /^\/#{path}\/*/
        @environment = ::Sprockets::Environment.new(@root)
        @environment.append_path "assets/javascripts"
        @environment.append_path "assets/javascripts/vendor"
        @environment.append_path "assets/stylesheets"
        @environment.append_path "assets/stylesheets/vendor"
        @environment.append_path "assets/images"
      end

      def call(env)
        return @app.call(env) unless @matcher =~ env["PATH_INFO"]
        env["PATH_INFO"].sub!(@matcher, "")
        @environment.call(env)
      end
    end
  end
end
