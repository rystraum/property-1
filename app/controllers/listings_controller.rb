class ListingsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @listings = @u.listings
  end
  
  def show
    @listing = @u.listings.find(params[:id])
  end
  
  def new
    @listing = @u.listings.build
  end
  
  def create
    @listing = @u.listings.build(params[:listing])
    
    if @listing.save
      redirect_to @listing
    else
      render :new
    end
  end
  
end
