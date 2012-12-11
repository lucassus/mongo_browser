module MongoBrowser
  module Middleware
    class SprocketsBase
      def call(env)
        return @app.call(env) unless @matcher =~ env["PATH_INFO"]
        env["PATH_INFO"].sub!(@matcher, "")
        @environment.call(env)
      end
    end
  end
end
