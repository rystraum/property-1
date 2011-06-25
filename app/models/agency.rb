class Agency < ActiveRecord::Base
  has_many :agents
  has_many :listings, through: :agents
  
  attr_accessible :name, :phone
  
end
