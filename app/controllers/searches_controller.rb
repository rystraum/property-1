class SearchesController < ApplicationController
  respond_to :js

  def new
    @search = Search.new
    respond_with @search
  end
  
  
end