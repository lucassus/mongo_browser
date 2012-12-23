class MongoBrowser::Application
  module Development
    def self.registered(app)

      app.register Sinatra::Reloader

      app.set :spec_root, File.join(settings.root, "../../spec")

      # Execute jasmine runner
      app.get "/jasmine" do
        File.read(File.join(settings.spec_root, "javascripts/runner.html"))
      end

      # Execute e2e runner
      app.get "/e2e" do
        File.read(File.join(settings.spec_root, "javascripts/runner_e2e.html"))
      end

      # Load database fixtures
      app.get "/e2e/load_fixtures" do
        require File.join(settings.spec_root, "support/fixtures")
        fixtures = Fixtures.instance

        fixtures.load!
        fixtures.load_documents!

        respond_to do |format|
          format.json { true }
        end
      end

    end
  end
end
