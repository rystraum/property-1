class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :phone
  
  validates_presence_of :email, :password, :password_confirmation
  
  has_many :listings
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
  def agent?
    # Reload in case object has been 'cast' to another type
    Agent === self.reload
  end

end
