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
  
  
end
