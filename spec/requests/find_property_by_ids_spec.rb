require 'spec_helper'

describe "FindPropertyByIds" do
  describe "GET /find_property_by_ids" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get find_property_by_ids_path
      response.status.should be(200)
    end
  end
end
