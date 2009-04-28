module MainHelper
  def filter_attribute_list a
    case a
    when 'created_at', 'updated_at', 'note' then return ''
	when 'name'
	  return text_field_tag("desire[#{a}]", nil, :class => a, :id => nil)
    else 
      return "<b>#{a}:</b> " + text_field_tag("desire[#{a}]", nil, :class => a)
    end
  end
end
