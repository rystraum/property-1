class PropertiesController < ApplicationController
  
  def index
    @properties = Property.all(include: :listings)
  end
  
  def show
    @property = Property.find(params[:id])
    @listing = @property.reference_listing
    render 'listings/show'
  end
  
end
