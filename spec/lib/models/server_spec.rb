require "spec_helper"

describe MongoBrowser::Models::Server do
  describe ".current" do
    it "instantiates an instance for the current (localhost) server" do
      server = described_class.current
      expect(server).to be_an_instance_of(described_class)
    end
  end

  subject { described_class.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port) }

  its(:host) { should == MongoBrowser.mongodb_host }
  its(:port) { should == MongoBrowser.mongodb_port }

  describe "#databases" do
    it "returns a collection of all available databases"
  end

end
