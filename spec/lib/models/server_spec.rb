require "spec_helper"

describe MongoBrowser::Models::Server do
  describe ".current" do
    it "instantiates an instance for the current (localhost) server" do
      server = described_class.current
      expect(server).to be_an_instance_of(described_class)
    end
  end

  let(:server) { described_class.new(MongoBrowser.mongodb_host, MongoBrowser.mongodb_port) }
  subject { server }

  its(:host) { should == MongoBrowser.mongodb_host }
  its(:port) { should == MongoBrowser.mongodb_port }

  describe "#connection" do
    it "returns a connection to the database" do
      connection = server.connection
      expect(connection).to be_an_instance_of(Mongo::Connection)
    end
  end

  describe "#databases" do
    let(:databases) { server.databases }
    subject { databases }

    it { should be_an_instance_of(Array) }
    it { should have(2).items }

    describe "first database" do
      subject { databases.find { |db| db.name == "first_database" }  }

      it { should be_an_instance_of(MongoBrowser::Models::Database) }
      its(:name) { should == "first_database" }
    end

    describe "second database" do
      subject { databases.find { |db| db.name == "second_database" }  }

      it { should be_an_instance_of(MongoBrowser::Models::Database) }
      its(:name) { should == "second_database" }
    end
  end

end
