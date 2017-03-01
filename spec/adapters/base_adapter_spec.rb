require 'spec_helper'

describe BaseAdapter do
 let(:config) {"spec/fixtures/sample.yml"}
 let(:source) {"spec/fixtures/sample.xml"}
 let(:fields) { YAML.load_file(config) }
 let(:parsed) { BaseAdapter.new(fields, source) }

  describe "initilize" do
    it { expect(parsed.doc).to be_an_instance_of(Nokogiri::XML::Document)}
    it { expect(parsed.root).to eq "//company"}
    it { expect(parsed.fields).to be_an_instance_of Hash}
  end

  describe "self.instance" do
    context :not_class do
      it {expect {BaseAdapter.instance(config, source)}.to raise_error "not implemented"}
    end
    context :class_exists do
      before do
        class TestAdapter < BaseAdapter
          self.register_class  /test/
        end
      end
      it {expect(BaseAdapter.instance(config, source)).to be_an_instance_of TestAdapter }
    end
  end

  before do
    @data = parsed.doc.xpath(parsed.root)
    @item = @data.first
  end
  describe "field_content" do
    it { expect(parsed.field_content(@data, "name")).to eq "Big Company" }
    it { expect(parsed.field_content(@data, "full_name")).to eq "" }
  end

  describe "item_keys" do
    it { expect(parsed.item_keys).to eq ["name", "fax"]}
  end

  describe :item_content do
    it { expect(parsed.item_content(@item)).to eq ["Big Company", "+1-233-345678"]}
  end

  describe "each_item" do
    it { expect {|b| parsed.each_item(&b)}.to yield_control.twice }
  end

end
