class Agencies::ListingsController < ApplicationController
  
  def index
    @listings = @g.listings
    render 'listings/index'
  end

  def show
  end
  
end
