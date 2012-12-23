require "sinatra"
require "sinatra/reloader"
require "sinatra/respond_with"

require "sprockets"
require "sass"
require "coffee_script"

require "mongo_browser/middleware/sprockets_sinatra"

module MongoBrowser
  class Application < Sinatra::Base

    enable :sessions

    set :root, File.join(File.dirname(__FILE__), "../../app")
    set :public_folder, File.join(settings.root, "../public")

    set :method_override, true

    register Sinatra::RespondWith

    use Middleware::SprocketsSinatra, :root => File.join(settings.root, "..")

    if settings.development? or settings.test?
      require "mongo_browser/middleware/sprockets_specs"
      use MongoBrowser::Middleware::SprocketsSpecs, :root => File.join(settings.root, "..")

      require "mongo_browser/application/development"
      register Development
    end

    # Loads given template from assets/templates directory
    get "/ng/templates/:name.html" do |template_name|
      send_file File.join(settings.root, "assets/templates/#{template_name}.html")
    end

    # Welcome page
    get "/*" do
      erb :index
    end
  end
end
