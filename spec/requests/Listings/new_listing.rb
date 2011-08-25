require 'spec_helper'

describe "new listing" do
  it "should be created with the minimum required fields" do
    
  end
    
  describe "'land is worth more than residence' checkbox" do
    let(:user) { Fabricate :user}
    
    it "should be enabled only when both 'residence' and land' are checked", js: true
    #   sign_in user
    #   visit new_listing_path
    #   check "listing_includes_residence_values"
    #   uncheck "listing_includes_land_values"
    #   # Add a be enabled/disabled matcher: https://github.com/dchelimsky/rspec/wiki/Custom-Matchers
    #   list_as_land = find_by_id("listing_list_as_land")
    #   list_as_land.should be_disabled
    #   check "listing_includes_land_values"
    #   list_as_land.should be_enabled
    # end
  end
end
