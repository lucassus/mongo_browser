require "spec_helper"

describe MongoBrowser do

  it "defines a default host" do
    expect(MongoBrowser.mongodb_host).to eq("localhost")
  end

end
