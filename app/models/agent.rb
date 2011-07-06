class Agent < User
  
  belongs_to :agency
  
  validates_presence_of :agency_id, :first_name, :last_name
  
  def admin?
    agency.admin == self
  end
  
end
