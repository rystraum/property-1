module ApplicationHelper
  
  # Assigned to <body> for scoping.
  def body_class
    [request.path_parameters[:controller], request.path_parameters[:action]].map(&:parameterize).join('--')
  end

  def m2
    "m<sup>2</sup>".html_safe
  end
    
end
