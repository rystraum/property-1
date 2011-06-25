class Property < ActiveRecord::Base
  has_many :listings
  
  def reference_listing
    listings.first
  end
  
end
