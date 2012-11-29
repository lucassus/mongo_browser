require "spec_helper"

describe MongoBrowser::Models::Database do
  let(:mongo_db_name) { "first_database" }
  let(:mongo_db) { MongoBrowser::Models::Server.current.connection[mongo_db_name] }

  let(:database) { described_class.new(mongo_db) }
  subject { database }

  its(:id) { should == mongo_db_name }
  its(:name) { should == mongo_db_name }

  its(:size) { should == 218103808 }
end
