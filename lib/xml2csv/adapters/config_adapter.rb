class ConfigAdapter < BaseAdapter

  def item_content(item)
    compound_fields = fields["compound"]
    content = super
    compound_fields.each do |compound_name, value|
      content << fields["compound"][compound_name].map{ |k,v| field_content(item,v) }.join(" ")
    end if compound_fields
    return content
  end

  self.register_class /config/
end
