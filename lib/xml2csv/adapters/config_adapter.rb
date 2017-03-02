class ConfigAdapter < BaseAdapter

  def header
    super + fields["compound"].to_a.map {|k,v| k}
  end
  
  def item_content(item)
    content = super
    compound_fields = fields["compound"]
    compound_fields.each do |compound_name, value|
      content << fields["compound"][compound_name].map{ |k,v| field_content(item,v) }.join(" ")
    end if compound_fields
    return content
  end

  self.register_class /config/
end
