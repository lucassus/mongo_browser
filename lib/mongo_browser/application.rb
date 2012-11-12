module MongoBrowser
  class Application < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), "../../app")
    use MongoBrowser::SprocketsSinatraMiddleware, :root => settings.root, :path => 'assets'

    get '/' do
      erb :index
    end
  end
end
