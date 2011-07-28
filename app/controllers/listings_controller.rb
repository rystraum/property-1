class ListingsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  # This should be listing with unique property_ids.  Where duplicate IDs an algorithm for the best choice for 
  # inclusion should exist that considers completeness of listing, quantitiy of pictures, reviews, ratings, etc.
  def index
    session[:search] = Search::DEFAULT_SEARCH if session[:search].nil? || params[:reset] == "true"
    @search = Search.new session[:search]
    @listings = @search.listings
  end
  
  def show
    @listing = Listing.find(params[:id])
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

  def edit
    @listing = @u.listings.find(params[:id])
  end
  
  def update
    @listing = @u.listings.find(params[:id])
    
    if @listing.update_attributes(params[:listing])
      redirect_to @listing
    else
      render :edit
    end
  end
end
