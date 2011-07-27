class SearchesController < ApplicationController
  respond_to :js

  def new
    params[:search] ||= Search::DEFAULT_PARAMS
    @search = Search.new(params[:search])
    respond_with @search
  end
  
  def create
    @search = Search.new(params[:search])
    render layout: false
    respond_with @search
  end
  
  
end