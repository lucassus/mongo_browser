require "spec_helper"

describe MongoBrowser::Models::Document do
  let(:db_name) { "first_database" }
  let(:collection_name) { "first_collection" }

  let(:server) { MongoBrowser::Models::Server.current }
  let(:colleciton) { server.connection[db_name].collection(collection_name) }
  let(:mongo_document) { colleciton.find.first }

  let(:document) { described_class.new(db_name, collection_name, mongo_document) }
  subject { document }

  its(:id) { should_not be_nil }
  its(:data) { should_not be_nil }
  its(:data) { should_not be_an_instance_of(Hash) }
end
