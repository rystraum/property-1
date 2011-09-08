module ApplicationHelper
  
  # Assigned to <body> for scoping.
  def body_class
    [request.path_parameters[:controller], request.path_parameters[:action]].map(&:parameterize).join('--')
  end

  def m2
    "<span class='unit'>m<sup>2</sup></span>".html_safe
  end
    
end
