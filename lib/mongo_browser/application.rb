require "sinatra"
require "sinatra/reloader"
require "sinatra/respond_with"

require "sprockets"
require "sass"
require "coffee_script"

require "mongo_browser/middleware/sprockets_sinatra"

module MongoBrowser
  class Application < Sinatra::Base
    set :logging, true
    set :root, File.join(File.dirname(__FILE__), "../../app")
    set :public_folder, Proc.new { File.join(root, "../public") }

    use Middleware::SprocketsSinatra, :root => File.join(settings.root, "..")

    if settings.development? or settings.test?
      require "mongo_browser/middleware/sprockets_specs"
      use Middleware::SprocketsSpecs, :root => File.join(settings.root, "..")

      require "mongo_browser/application/development"
      register Development
    end

    # Welcome page
    get "/*" do
      erb :index
    end
  end
end
