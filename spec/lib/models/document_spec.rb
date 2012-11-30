require "spec_helper"

describe MongoBrowser::Models::Document do
  let(:mongo_db_name) { "first_database" }
  let(:mongo_collection_name) { "first_collection" }

  let(:server) { MongoBrowser::Models::Server.current }
  let(:mongo_collection) { server.connection[mongo_db_name].collection(mongo_collection_name) }
  let(:mongo_document) { mongo_collection.find.first }

  let(:document) { described_class.new(mongo_document) }
  subject { document }

  its(:id) { should_not be_nil }
  its(:data) { should_not be_nil }
  its(:data) { should_not be_an_instance_of(Hash) }
end
