class Property < ActiveRecord::Base
  has_many :listings
  
  # STUB
  def reference_listing
    listings.first
  end
  
end
