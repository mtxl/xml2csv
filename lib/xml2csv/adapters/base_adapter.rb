class BaseAdapter
  @@adapters = []

  attr_reader :fields, :doc, :root

  def self.register_class(name)
    @@adapters << [self, name]
  end

  def initialize(fields, source)
    @fields = fields
    @doc = Nokogiri::XML(File.open(source))
    @root = @fields["item_root"]
  end

  def self.instance(config_file, source)
    fields = YAML.load_file(config_file)
    name = fields["class_name"]
    match = @@adapters.find {|klass, exp| name =~ exp}
    raise 'not implemented' if match.nil?
    match.first.new fields, source
  end

  def field_content(data, key)
    field = data.xpath(".//#{key}").first
    field ? field.content.strip : ""
  end

  def item_keys
    fields["item"].map {|k,v| k }
  end

  alias_method :header, :item_keys
  
  def item_content(item)
    item_keys.map{ |key| field_content(item, fields["item"][key])}
  end

  def each_item
    begin
      items = @doc.xpath(root)
      items.each do |item|
        yield item_content(item)
      end
    rescue
    end
  end
end
