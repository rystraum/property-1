class Agency < ActiveRecord::Base
  has_many :agents
  has_many :listings, through: :agents
  
  attr_accessor :admin
  
  attr_accessible :name, :phone
  
  validates_presence_of :name
  validate :validates_presence_of_admin
  
  after_create :add_admin
  
  def admin
    agents.find(admin_id)
  end
  
  def add_user_as_agent(user)
    user.type = "Agent"
    user.agency_id = self.id
    user.save!
    user.becomes(Agent)
  end
  
  
  protected
  
  def add_admin
    user = User.find(admin_id || @admin.id)
    admin = add_user_as_agent(user)
    agents << admin
    self.admin_id = admin.id
    save!
  end
  
  def validates_presence_of_admin
    errors.add(:base, "Agency must have an admin") unless @admin || admin_id
  end
  
end
