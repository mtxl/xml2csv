require 'spec_helper'

describe ConfigAdapter do
  let(:config) {"spec/fixtures/config_adapter.yml"}
  let(:source) {"spec/fixtures/sample.xml"}
  let(:fields) { YAML.load_file(config) }
  let(:parsed) { ConfigAdapter.new(fields, source) }
  describe :item_content do
    it do
      @item = parsed.doc.xpath(parsed.root)
      expect(parsed.item_content(@item)).to eq (
      ["Big Company", "+1-233-345678", "+7-499-876321 Big Company", 
       "Big Company +1-233-345678"])
    end
  end
  
end
