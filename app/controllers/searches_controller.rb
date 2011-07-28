class SearchesController < ApplicationController
  respond_to :js
  
  def create
    format_postions
    session[:search] = params[:search]
    @search = Search.new session[:search]
  end
  
  
  protected
  
  def format_postions
    if params[:search][:bounds].is_a? String
      sw_bounds, ne_bounds = Search.format_positions(params[:search][:bounds])
      params[:search][:bounds] = [sw_bounds, ne_bounds]
    end
    if params[:search][:center].is_a? String
      params[:search][:center] = Search.format_positions(params[:search][:center]).first
    end
  end
  
  
end