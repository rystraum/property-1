require 'spec_helper'

describe Property do
  
  it "should be valid" do
    property = Fabricate :property
    property.should be_valid
  end
  
end
