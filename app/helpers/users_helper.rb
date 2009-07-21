module UsersHelper
  def to_class priority, meet
    meet = meet ? ' meet' : ''
    (['', 'non-urgent', 'urgent', 'emergent'][priority] + meet).strip
  end
end
