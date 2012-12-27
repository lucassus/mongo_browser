require "spec_helper"

describe MongoBrowser::Models::Pager do
  let(:page) { 1 }
  let(:size) { 25 }

  let(:pager) { described_class.new(page, size) }
  subject { pager }

  before { pager.stub(:per_page).and_return(25) }

  describe "#page" do
    subject { pager.page }

    [-2, -1, 0, 1].each do |number|
      context "when the given page number is #{number}" do
        let(:page) { number }

        it("return the first page") { should == 1 }
      end
    end

    context "when the given page number exceed the total pages number" do
      let(:page) { 3 }
      let(:size) { 30 }

      it("returns the last page number") { should == 2 }
    end

    context "otherwise" do
      let(:page) { 2 }
      let(:size) { 26 }

      it("returns the current page") { should == page }
    end
  end

  describe "#offset" do
    subject { pager.offset }

    context "when page eq 1" do
      it { should == 0 }
    end

    context "otherwise" do
      let(:page) { 2 }
      let(:size) { 26 }

      it("return a valid offset") { should == 25 }
    end
  end

  describe "#total_pages" do
    subject { pager.total_pages }

    { 0 => 1, 1 => 1, 25 => 1, 26 => 2, 50 => 2, 51 => 3, 101 => 5 }.each do |size, expected|
      context "when the size is #{size}" do
        let(:size) { size }

        it { should == expected }
      end
    end
  end

  describe "#to_hash" do
    subject { pager.to_hash }

    it { should be_an_instance_of(Hash) }
    its([:size]) { should == 25 }
    its([:page]) { should == 1 }
    its([:total_pages]) { should == 1 }
  end
end
