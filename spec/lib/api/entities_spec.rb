require "spec_helper"

describe MongoBrowser::Api::Entities::Database do
  let(:database) { mock }
  subject(:database_entity) { described_class.new(database) }

  it { should expose :name }
  it { should expose :size }
  it { should expose :count }
end

describe MongoBrowser::Api::Entities::Collection do
  let(:collection) { mock }
  subject(:database_entity) { described_class.new(collection) }

  it { should expose :dbName }
  it { should expose :name }
  it { should expose :size }
end

describe MongoBrowser::Api::Entities::Document do
  let(:document) { mock }
  subject(:database_entity) { described_class.new(document) }

  it { should expose :id }
  it { should expose :data }
end

describe MongoBrowser::Api::Entities::PagedDocuments do
  let(:pager) { mock }
  subject(:database_entity) { described_class.new(pager) }

  it { should expose :page }
  it { should expose :size }
  it { should expose :totalPages }
  it { should expose :documents }
end
