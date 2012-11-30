require "spec_helper"

describe MongoBrowser do

  it "defines a default host" do
    expect(MongoBrowser.mongodb_host).to eq("127.0.0.1")
  end

end
