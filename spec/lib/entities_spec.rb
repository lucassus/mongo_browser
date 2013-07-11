require "spec_helper"

describe MongoBrowser::Entities::Database do
  let(:database) { double }
  subject(:database_entity) { described_class.new(database) }

  it { should expose :name }
  it { should expose :size }
  it { should expose :count }
end

describe MongoBrowser::Entities::Collection do
  let(:collection) { double }
  subject(:database_entity) { described_class.new(collection) }

  it { should expose :dbName }
  it { should expose :name }
  it { should expose :size }
end

describe MongoBrowser::Entities::Document do
  let(:document) { double }
  subject(:database_entity) { described_class.new(document) }

  it { should expose :id }
  it { should expose :data }
end

describe MongoBrowser::Entities::PagedDocuments do
  let(:pager) { double }
  subject(:database_entity) { described_class.new(pager) }

  it { should expose :page }
  it { should expose :size }
  it { should expose :totalPages }
  it { should expose :documents }
end
