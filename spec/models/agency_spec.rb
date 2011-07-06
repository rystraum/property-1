require 'spec_helper'

def named_user
  Fabricate :user, first_name: "Bob", last_name: "Smith"
end

describe Agency do
  
  it "should be valid" do
    agency = Fabricate :agency
    agency.should be_valid
  end
  
  describe "validations" do
    it "should validate presence of an admin" do
      lambda { 
        Fabricate :agency, admin: nil, admin_id: nil 
      }.should raise_error(ActiveRecord::RecordInvalid, /Agency must have an admin/)

      lambda {
        Fabricate :agency, admin: named_user
      }.should_not raise_error
    end
  end
  
  
  it "should know its admin" do
    user = named_user
    agency = Fabricate :agency, admin: user
    admin = user.reload.becomes(Agent)
    agency.admin.should == admin
  end
  
  it "should add a user as an agent" do
    agency = Fabricate :agency
    count = agency.agents.count

    agency.add_user_as_agent(named_user)
    agency.agents.count.should == count + 1
  end
    
  
end
