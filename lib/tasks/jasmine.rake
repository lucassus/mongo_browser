begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'

  Rake::Task["jasmine:server"].clear
  Rake::Task["jasmine:ci"].clear

  namespace :jasmine do
    # desc "Run specs via server"
    task :server => "jasmine:require" do
      config = Jasmine::Config.new
      root_path = config.project_root

      jasmine_config_overrides = File.join(config.project_root, 'spec', 'javascripts' ,'support' ,'jasmine_config.rb')
      require jasmine_config_overrides if File.exist?(jasmine_config_overrides)

      port = ENV['JASMINE_PORT'] || 8888
      puts "your tests are here:"
      puts "  http://localhost:#{port}/"

      # TODO dry it
      app = Jasmine::Application.app

      app = Rack::Builder.new(app) do |app|
        app.use Rack::CoffeeCompiler,
            source_extension: 'js.coffee',
            source_dir: File.join(root_path, 'spec/javascripts'),
            url: config.spec_path

        app.use Rack::CoffeeCompiler,
            source_extension: 'js.coffee',
            source_dir: File.join(root_path, 'app/assets/javascripts'),
            url: '/app/assets/javascripts'
      end

      Jasmine::Server.new(port, app).start
    end

    desc "Run continuous integration tests"
    task :ci => ["jasmine:require_json", "jasmine:require"] do
      require "rspec"
      require "rspec/core/rake_task"

      RSpec::Core::RakeTask.new(:jasmine_continuous_integration_runner) do |t|
        t.rspec_opts = ["--colour", "--format", ENV['JASMINE_SPEC_FORMAT'] || "progress"]
        t.verbose = true

        config = Jasmine::Config.new
        root_path = config.project_root
        t.pattern = [File.join(root_path, "spec/javascripts/support/jasmine_runner.rb")]
      end

      Rake::Task["jasmine_continuous_integration_runner"].invoke
    end
  end
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
