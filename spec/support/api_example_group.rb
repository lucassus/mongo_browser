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
    def describe_endpoint(method, interpolated_path, &block)
      describe "#{method.upcase} #{interpolated_path}" do
        let(:path) do
          path = interpolated_path.clone
          interpolated_path.scan(/(:(\w+))/).each do |place_holder, name|
            path.sub!(place_holder, instance_eval(name).to_s)
          end

          path
        end

        let(:do_request) { send(method.downcase.to_sym, path) }
        subject(:response) { do_request }

        instance_eval(&block)
      end
    end
  end
end
