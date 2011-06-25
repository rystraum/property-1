class AgencyController < ApplicationController
  before_filter :admin_only!, except: :show
  
  def show
    @agency = @a.agency
  end

  def create
    params[:agency].merge!(admin_id: @u.id)
    @agency = Agency.new(params[:agency])

    if @agency.save
      @u.type = "Agent"; @u.save!
      @agency.agents << @u.becomes(Agent)
      flash[:notice] = "Your agency has been created."
      redirect_to :agency
    else
      render 'users/edit'
    end
  end
  
end
