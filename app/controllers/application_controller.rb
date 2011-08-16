class ApplicationController < ActionController::Base
  protect_from_forgery

  AGENCY_ROUTE = /^\/agency/
  
  before_filter :set_user_instance_vars, if: proc{ signed_in? }

  
  protected
  
  def set_user_instance_vars
    if current_user.agent?
      @a = current_user
      @g = @a.agency
    end
    @u = current_user.becomes(User)
  end
  
  def agency_route?
    AGENCY_ROUTE === request.path
  end
  helper_method :agency_route?
  
  def admin_only!
    redirect_to root_path, alert: "Either the page you requested does not exist or you or not authorized to access it." unless admin?
  end
  
  def admin?
    @a && @a.admin?
  end
  helper_method :admin?
  
  def disable_caching
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
end
