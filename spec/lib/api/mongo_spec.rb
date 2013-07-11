require "spec_helper"

describe MongoBrowser::Api::Mongo do
  include ApiExampleGroup

  def app
    described_class
  end

  describe_endpoint :get, "/server_info" do
    it { should be_successful }

    it "returns info about the server" do
      server_info = JSON.parse(response.body)
      expect(server_info).to_not be_empty
    end
  end

  describe_endpoint :get, "/version" do
    it { should be_successful }

    it "returns application version" do
      data = JSON.parse(response.body)
      expect(data["version"]).to eq(MongoBrowser::VERSION)
    end
  end
end
