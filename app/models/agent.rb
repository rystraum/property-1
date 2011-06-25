class Agent < User
  
  belongs_to :agency
  
  validates_presence_of :first_name, :last_name
  
  def admin?
    agency.admin_id == id
  end
  
end
