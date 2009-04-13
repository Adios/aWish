module WantsHelper
  def generate_item_classes data
    c = Array.new
    if data.purchase
      c << "purchased" 
      return c.join(" ")
    end
    
    case data.priority
    when 0 then return c.join(" ")
    when 1 then c << "non-urgent"
    when 2 then c << "urgent"
    when 3 then c << "emergent"
    end
    
    c.join(" ")
  end
end
