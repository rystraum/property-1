class UsersController < ApplicationController
  
  def edit
  end
  
  def update
    if @u.update_attributes(params[:user])
      redirect_to @u
    else
      render :edit
    end
  end
end
