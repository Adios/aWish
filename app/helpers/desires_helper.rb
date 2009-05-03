module DesiresHelper
  def budget_or_spent desire
    if desire.meet 
      desire.feedback.spent ? 'spent $' + desire.feedback.spent.to_i.to_s : ''
    else
      desire.budget ? 'under $' + desire.budget.to_i.to_s : ''
    end
  end
  
  def priority_message p
    [ '<span title="I want it.">50%</span>', 
      '<span title="I hope have one.">80%</span>', 
      '<span title="I will buy!">100%</span>', 
      '<span title="I must buy!">200%</span>' 
    ].at(p)
  end
  
  def edit?
    (controller.action_name == 'edit') ? true : false
  end
end
