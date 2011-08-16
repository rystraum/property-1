class SearchesController < ApplicationController
  respond_to :js
  
  def new
    session[:search] = Search::DEFAULT_SEARCH
    redirect_to listings_path
  end
  
  def create
    session[:search] = format_params
    @search = Search.new(session[:search])
  end
  
  
  protected
  
  def format_params
    params[:search][:center] = format_center(params[:search][:center])
    params[:search][:bounds] = format_bounds(params[:search][:bounds])
    params[:search]
  end
  
  def format_center(center)
     Search.format_positions(center).first if center.is_a?(String)
  end
  
  def format_bounds(bounds)
    if bounds.is_a?(String)
      sw_bounds, ne_bounds = Search.format_positions(bounds)
      [sw_bounds, ne_bounds]
    end
  end  
  
end