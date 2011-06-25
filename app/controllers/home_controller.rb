class HomeController < ApplicationController

  def index
    # This should be listing with unique property_ids.  Where duplicate IDs an algorithm for the best choice for 
    # inclusion should exist that considers completeness of listing, quantitiy of pictures, reviews, ratings, etc.
    @listings = Listing.all
  end

end
