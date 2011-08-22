require 'spec_helper'

describe Search do
  
  describe "class method" do
    it "#format_positions should extract positions from string" do
      google_bounds_string = '((5.0, -10.0), (9.0, -4.0))'
      positions = Search.format_positions google_bounds_string
      positions.should == [[5.0, -10.0], [9.0, -4.0]]
    end
    
  end
  
  it "should know its bounds" do
    search = Fabricate.build :search, sw_bounds: [5, -10], ne_bounds: [9, -4]
    search.bounds.should == [[5, -10], [9, -4]]
  end
  
  # Testing all protected scopes that build the listing search results.
  describe "listings" do
    
    it "should only return specified residence types" do
      listing1 = Fabricate :residence_listing, residence_type: 'house'
      listing2 = Fabricate :residence_listing, residence_type: 'private_room'
      search = Fabricate.build :search, house: true
      search.send(:residence_type_scope, Listing.scoped).should == [listing1]
    end
    
    it "should include those 'for sale' when only 'for rent' is specified if listings are both 'for rent' and 'for sale'" do
      listing = Fabricate :listing, selling_price: 10000, rent_per_day: 1000
      search = Fabricate.build :search, for_rent: true
      search.send(:sale_or_rent_scope, Listing.scoped).should == [listing]
    end
  end
  
  
end
