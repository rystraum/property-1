require 'spec_helper'

describe User do
  
  it "should be valid" do
    user = Fabricate :user
    user.should be_valid
  end
  
  it "should have a full name" do
    user = Fabricate :user, first_name: "Gavin", last_name: "Hughes"
    user.full_name.should == "Gavin Hughes"
  end
  
  it "should know if it is an agent, even if 'cast'" do
    user = Fabricate :agent
    user.agent?.should be_true
  end
  
end
