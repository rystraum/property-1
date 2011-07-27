class Agent < User
  
  belongs_to :agency
  
  validates_presence_of :agency_id, :first_name, :last_name
  delegate :name, :to => :agency, :prefix => true, :allow_nil => false  
  
  def admin?
    agency.admin == self
  end
  
end
