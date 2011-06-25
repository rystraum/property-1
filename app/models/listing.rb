class Listing < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  
  validates_presence_of :user, :latitude, :longitude, :title, :lister_interest
  
  # When listing is created, it creates property if none currently exists.
  # User adding new property listing should first determine if the same property is already listed.
  
  after_create :create_property
  
  
  protected
  
  # TODO: If very nearby properties exist, the UI needs to give the user an opportunity to determine if one of these
  #       is the same property. Selecting it will apply the property ID to this listing.
  #       For now the mechanism doesn't exist, so we just create new properies for every listing.
  def create_property
    Property.create!.listings << self
  end
end
