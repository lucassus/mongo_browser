require "sinatra"
require "sinatra/reloader"
require "sinatra/json"

module MongoBrowser
  class Application < Sinatra::Base
    set :logging, true
    set :root, File.join(File.dirname(__FILE__), "../../app")
    set :public_folder, Proc.new { File.join("frontend", "public") }

    if settings.development? or settings.test?
      require "mongo_browser/application/development"
      register Development
    end

    # Serve compiled home page
    get "/*" do
      send_file File.join(settings.public_folder, "index.html")
    end
  end
end
