$:.unshift(ENV['JASMINE_GEM_PATH']) if ENV['JASMINE_GEM_PATH'] # for gem testing purposes

require 'rubygems'
require 'jasmine'
jasmine_config_overrides = File.expand_path(File.join(Dir.pwd, 'spec', 'javascripts', 'support', 'jasmine_config.rb'))
require jasmine_config_overrides if File.exist?(jasmine_config_overrides)
require 'rspec'

jasmine_runner_config = Jasmine::RunnerConfig.new
root_path = jasmine_runner_config.project_root

app = Jasmine::Application.app(jasmine_runner_config)

# TODO dry it
app = Rack::Builder.new(app) do |app|
  app.use Rack::CoffeeCompiler,
          source_extension: 'js.coffee',
          source_dir: File.join(root_path, 'spec/javascripts'),
          url: jasmine_runner_config.spec_path

  app.use Rack::CoffeeCompiler,
          source_extension: 'js.coffee',
          source_dir: File.join(root_path, 'app/assets/javascripts'),
          url: '/app/assets/javascripts'
end

server = Jasmine::Server.new(jasmine_runner_config.port, app)
client = Jasmine::SeleniumDriver.new(jasmine_runner_config.browser,
                                     "#{jasmine_runner_config.jasmine_host}:#{jasmine_runner_config.port}/")

t = Thread.new do
  begin
    server.start
  rescue ChildProcess::TimeoutError
  end
  # # ignore bad exits
end
t.abort_on_exception = true
Jasmine::wait_for_listener(jasmine_runner_config.port, "jasmine server")
puts "jasmine server started."

results_processor = Jasmine::ResultsProcessor.new(jasmine_runner_config)
results = Jasmine::Runners::HTTP.new(client, results_processor).run
formatter = Jasmine::RspecFormatter.new
formatter.format_results(results)
