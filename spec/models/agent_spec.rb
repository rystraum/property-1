require 'spec_helper'

describe Agent do
  
  it "should be valid" do
    agent = Fabricate.build :agent
    agent.should be_valid
  end
  
  it "should know if it is an admin" do
    agency = Fabricate :agency
    agent = agency.admin

    agent.admin?.should be_true
    
    user = Fabricate :user, first_name: "Tom", last_name: "Jones"
    agent = agency.add_user_as_agent(user)

    agent.admin?.should be_false
  end
  
end
