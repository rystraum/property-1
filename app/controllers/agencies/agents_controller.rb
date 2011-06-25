class Agencies::AgentsController < InheritedResources::Base
  belongs_to :agency
  before_filter :authenticate_user!
  before_filter :admin_only!, except: [:index, :show]
  
end
