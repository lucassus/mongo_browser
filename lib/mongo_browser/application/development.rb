class MongoBrowser::Application
  module Development
    def self.registered(app)
      app.helpers Sinatra::JSON

      app.register Sinatra::Reloader

      app.set :spec_root, File.join(app.settings.root, "../spec")

      # Load database fixtures
      app.get "/e2e/load_fixtures" do
        require File.join(app.settings.spec_root, "support/fixtures")
        fixtures = Fixtures.instance

        fixtures.load!
        fixtures.load_documents!

        json success: true
      end
    end
  end
end
