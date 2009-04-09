module WantsHelper
  def generate_item_classes data
    classes = "item"
  
    if data.purchase
      classes += " purchased" 
      return classes
    end
    
    case data.priority
    when 0 then return classes;
    when 1 then classes += " little"
    when 2 then classes += " medium"
    when 3 then classes += " large"
    end
    
    classes
  end
end
