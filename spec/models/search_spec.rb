require 'spec_helper'

describe Search do
  
  it "should know its bounds" do
    search = Search.fabricate_build sw_lat: 5, sw_lng: -10, ne_lat: 9, ne_lng: -4
    search.bounds.should == [[5, -10], [9, -4]]
  end
  
  it "should extract bounds from a Google bounds string in the params" do
    search = Search.new 'bounds' => '((5, -10), (9, -4))'
    search.bounds.should == [[5, -10], [9, -4]]
  end
  
end
