require "spec_helper"
require "mongo_browser/cli"

describe MongoBrowser::CLI do

  describe "#start" do
    let(:runner) { double("runer", run!: true) }
    before { Thin::Runner.stub(:new).and_return(runner) }

    it "starts the application" do
      args = ["start", "--port=1234"]
      MongoBrowser::CLI.start(args)

      expect(Thin::Runner).to have_received(:new).with(kind_of(Array))
      expect(runner).to have_received(:run!)
    end
  end

end
