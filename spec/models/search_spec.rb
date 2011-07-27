require 'spec_helper'

describe Search do
  
  it "should know its bounds" do
    search = Fabricate.build :search, sw_bounds: [5, -10], ne_bounds: [9, -4]
    search.bounds.should == [[5, -10], [9, -4]]
  end
  
  it "should extract bounds from a Google bounds string in the params" do
    search = Search.new bounds: '((5.0, -10.0), (9.0, -4.0))'
    # search = Fabricate.build :search, bounds: '((5.0, -10.0), (9.0, -4.0))'
    search.bounds.should == [[5.0, -10.0], [9.0, -4.0]]
  end
  
end
