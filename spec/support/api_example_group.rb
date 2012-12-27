module ApiExampleGroup
  include Rack::Test::Methods

  def self.included(base)
    base.let(:server) { MongoBrowser::Models::Server.current }
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Helper for describing API endpoints
    #
    # Usage:
    #   describe_endpoint :delete, "/databases/:db_name" do
    #     let(:db_name) { "first_database" }
    #     # some assertions here
    #   end
    def describe_endpoint(method, route_path, &block)
      describe "#{method.upcase} #{route_path}" do
        let(:path) do
          path = route_path.clone
          route_path.scan(/(:(\w+))/).each do |place_holder, name|
            path.sub!(place_holder, instance_eval(name).to_s)
          end

          path
        end

        let(:do_request) { send(method.downcase.to_sym, path) }
        subject(:response) { do_request }

        # Create a new context with route description
        by_path = -> route { route.route_path.match(/^#{route_path.split("?").first}/) }
        route = described_class.routes.find(&by_path)

        if route and route.route_description
          describe route.route_description do
            instance_eval(&block)
          end
        else
          instance_eval(&block)
        end
      end
    end
  end
end
