require "spec_helper"

describe Xml2csv do
  it "has a version number" do
    expect(Xml2csv::VERSION).not_to be nil
  end

  context :process do
    subject {Xml2Csv.process}
    it {is_expected.to eq(true)}
  end
end
