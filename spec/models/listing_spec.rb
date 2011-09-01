require 'spec_helper'

describe Listing do
  
  it "should be valid" do
    listing = Fabricate.build :listing
    listing.should be_valid
  end
  
  describe "validations" do
    it "should validate that an alt contact phone or email exists if an alt contact is specified" do
      listing = Fabricate.build :listing, includes_alt_contact_values: true, contact_phone: nil, contact_email: nil
      
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
      listing = Fabricate.build :no_residence_or_land_invalid_listing
      listing.should_not be_valid
      listing.errors[:base].should == ["Listing must include a residence or land."]
      
      listing = Fabricate.build :residence_listing
      listing.should be_valid
      
      listing = Fabricate.build :land_listing
      listing.should be_valid
    end
    
    describe "on required residence attributes" do
      it "should not be valid when all are missing" do
        listing = Fabricate.build :listing, includes_residence_values: false
        listing.should be_valid
      
        listing.includes_residence_values = true
        listing.should_not be_valid
        (listing.errors.keys - Listing::REQUIRED_RESIDENCE_ATTRIBUTES).should == []
      end
      
      it "should not be valid when one is missing" do
        listing = Fabricate.build :listing, includes_residence_values: false
        listing.should be_valid
        
        listing.residence_area = 100
        missing_attributes = Listing::REQUIRED_RESIDENCE_ATTRIBUTES - [:residence_area]
        listing.should_not be_valid
        (listing.errors.keys - missing_attributes).should == []
      end
      
      it "should be valid when all are present, even when residence values specified as not included" do
        listing = Fabricate.build :residence_listing, includes_residence_values: false
        listing.should be_valid
      end
    end
    
    
    it "should validate presence of required land attributes if land is specified" do
      listing = Fabricate.build :land_listing, includes_land_values: false
      listing.should be_valid
      
      listing = Fabricate.build :no_residence_or_land_invalid_listing, includes_land_values: true
      listing.should_not be_valid
      (listing.errors.keys - Listing::REQUIRED_LAND_ATTRIBUTES).should == []
    end

    it "should validate the format of latitude" do
      listing = Fabricate :listing, latitude: "N 12.32"
      listing.should be_valid
      listing.latitude = -2.323
      listing.should be_valid
      listing.latitude = "N 234.23"
      listing.should_not be_valid
      listing.latitude = 234.23
      listing.should_not be_valid
      listing.errors[:latitude].should == ["is invalid"]
    end

    it "should validate the format of longitude" do
      listing = Fabricate :listing, longitude: "E 12.32"
      listing.should be_valid
      listing.longitude = -2.323
      listing.should be_valid
      listing.longitude = "E 234.23"
      listing.should_not be_valid
      listing.longitude = 234.23
      listing.should_not be_valid
      listing.errors[:longitude].should == ["is invalid"]
    end

  end # validations
  
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

  it "should store an appropriately formatted string latitude as a float" do
    listing = Fabricate :listing, latitude: "N 10.108982"
    listing.latitude.should == 10.108982
  end

  it "should store an appropriately formatted string longitude as an integer" do
    listing = Fabricate :listing, longitude: "W 121.3422"
    listing.longitude.should == -121.3422
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
  
  describe "required residence values" do
    before(:each) do
      @listing = Fabricate.build :listing, includes_residence_values: false
      Listing::REQUIRED_RESIDENCE_ATTRIBUTES.each { |a| @listing.send("#{a}=", nil) }
      @listing.includes_residence_values.should be_false
    end
    
    it "should be considered included if specified as included, even when no values are present" do
      @listing.includes_residence_values = true
      @listing.includes_residence_values.should be_true # Method considers the values of attributes, ergo the test.
    end
    
    it "should be considered included even if not specified as included when a value is present" do  
      @listing.includes_residence_values = false
      @listing.residence_area = 100
      @listing.includes_residence_values.should be_true
    end
  end
  
  describe "required land values" do
    before(:each) do
      @listing = Fabricate.build :listing, includes_land_values: false
      Listing::REQUIRED_LAND_ATTRIBUTES.each { |a| @listing.send("#{a}=", nil) }
      @listing.includes_land_values.should be_false
    end
    
    it "should be considered included if specified as included, even when no values are present" do
      @listing.includes_land_values = true
      @listing.includes_land_values.should be_true # Method considers the values of attributes, ergo the test.
    end
    
    it "should be considered included even if not specified as included when a value is present" do  
      @listing.includes_land_values = false
      @listing.land_area = 100
      @listing.includes_land_values.should be_true
    end
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
