require "spec_helper"

describe MongoBrowser::Models::Database do
  let(:mongo_db) { MongoBrowser::Models::Server.current.connection["first_database"] }

  let(:database) { described_class.new(mongo_db) }
  subject { database }

  its(:name) { should == "first_database" }
end
