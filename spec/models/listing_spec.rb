require 'spec_helper'

describe Listing do
  
  it "should be valid" do
    listing = Fabricate.build :listing
    listing.should be_valid
  end
  
  describe "validations" do
    it "should validate that an alt contact phone or email exists if an alt contact is specified" do
      listing = Fabricate.build :listing, specify_alt_contact: true, contact_phone: nil, contact_email: nil
      
      listing.should_not be_valid
      listing.errors[:base].should == ["Alternate contact must have a phone number or email."]
      
      listing.contact_email = "gavin@gavin.com"
      listing.should be_valid
    end
    
    it "should validate presence of either a selling price or a rental rate" do
      rental_rates = Listing::RENTAL_TERM_ATTRIBUTES.inject({}) { |h,m| h.merge!(m => nil) }
      listing = Fabricate.build :listing, { selling_price: nil }.merge!(rental_rates)
      
      listing.should_not be_valid
      listing.errors[:base].should == ["Listing must include a selling price or a rental rate."]
      
      listing.selling_price = 100
      listing.should be_valid
      
      listing.selling_price = nil
      listing.should_not be_valid
      
      listing.rent_per_day = 100
      listing.should be_valid
    end
    
    it "should validate presence of either residence or land" do
      listing = Fabricate.build :listing, residence_construction: nil, land_area: nil
      
      listing.should_not be_valid
      listing.errors[:base].should == ["Listing must include a residence or land."]
      
      listing.residence_type = Listing::RESIDENCE_TYPES.first
      listing.should be_valid
      
      listing.residence_type = nil
      listing.should_not be_valid
      
      listing.land_area = 100
      listing.should be_valid
    end
    
    it "should validate the presence of residence type, construction and area if residence is specified" do
      listing = Fabricate.build :listing, specify_residence: false
      listing.should be_valid
      
      listing = Fabricate.build :listing, specify_residence: true
      listing.should_not be_valid
      listing.errors.count.should == 3
      (listing.errors.keys - Listing::REQUIRED_RESIDENCE_ATTRIBUTES).should == []
    end
  end
  
  it "when created should associate itself with a new property if a property association has not been specified" do
    listing = Fabricate :listing, property: nil
    listing.property.should_not be_nil
    
    property = Fabricate :property
    listing = Fabricate :listing, property: property
    listing.property.should == property
  end
  
  it "when destroyed should destroy its parent property if it was the last listing for that property" do
    listing = Fabricate :listing
    property = listing.property
    listing.destroy
    property.destroyed?.should be_true
  end
  
  it "should know if it is for sale" do
    listing = Fabricate.build :listing, selling_price: nil
    listing.for_sale?.should be_false
    
    listing.selling_price = 100
    listing.for_sale?.should be_true
  end
  
  it "should know if it is for rent" do
    listing = Fabricate.build :listing, rent_per_day: nil
    listing.for_rent?.should be_false
    
    listing.rent_per_day = 100
    listing.for_rent?.should be_true
  end
  
  it "should know if it has a residence" do
    listing = Fabricate.build :listing, residence_type: nil
    listing.has_residence?.should be_false
    
    listing.residence_type = Listing::RESIDENCE_TYPES.first
    listing.has_residence?.should be_true
  end
  
  it "should know if it has land" do
    listing = Fabricate.build :listing, land_area: nil
    listing.has_land?.should be_false
    
    listing.land_area = 100
    listing.has_land?.should be_true
  end
  
  it "should know if it has an alt contact" do
    listing = Fabricate.build :listing, contact_phone: nil, contact_email: nil
    listing.has_alt_contact?.should be_false
    
    listing.contact_phone = "09174398888"
    listing.has_alt_contact?.should be_true
    
    listing.contact_phone = nil
    listing.has_alt_contact?.should be_false
    
    listing.contact_email = "gavin@gavin.com"
    listing.has_alt_contact?.should be_true
  end
  
end
