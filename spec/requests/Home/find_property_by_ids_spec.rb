require 'spec_helper'

describe "FindPropertyByIds" do
  describe "GET /find_property_by_ids" do
    
    it "opens the show page on success", js: true do
      user = Fabricate :user
      listing = Fabricate :listing
      visit root_path
      fill_in 'listing_id', with: listing.id
      click_button 'find_listing_button'
      current_path.should eq(listing_path listing.id)
    end
  end
end
