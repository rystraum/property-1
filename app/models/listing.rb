class Listing < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  
  RESIDENCE_CONSTRUCTIONS = ['Native materials', 'Basic materials', 'Modern construction', 'Elegant']
  RESIDENCE_TYPES = ['House', 'Duplex or other multi-unit home', 'Apartment, flat or condominium', 'Bungalow, chalet or cabin', 'Private room', 'Shared room']
  RENTAL_TERM_METHODS = [:rent_per_day, :rent_per_week, :rent_per_month, :rent_per_month_biannual_contract, :rent_per_month_annual_contract]

  attr_writer :has_residence, :has_land, :specify_alt_contact

  validates_presence_of :user, :latitude, :longitude, :title
  validates_presence_of :property, on: :update

  with_options allow_blank: :true do |v|
    v.validates_inclusion_of :residence_construction, in: RESIDENCE_CONSTRUCTIONS
    v.validates_inclusion_of :residence_type, in: RESIDENCE_TYPES
    v.validates_numericality_of :land_area, greater_than: 0
    v.validates_numericality_of *RENTAL_TERM_METHODS, :selling_price, integer_only: true, greater_than: 0
  end
  
  validate :validates_presence_of_alt_contact_phone_or_email
  validate :validates_for_sale_or_rent
  
  # TODO: User adding new listing should first determine if the property is already listed. If so, the listing must be associated with the other existing property.
  #
  after_create :create_property
  
  # TODO: How to coerce AR/AM to handle this?
  # TEST!
  #
  # For form handling.
  def specify_alt_contact
    @specify_alt_contact = nil if @specify_alt_contact == "0"
    @specify_alt_contact || has_alt_contact?
  end
  
  # TODO: Nillify blanks
  #
  def has_residence?
    !residence_type.blank?
  end
  
  def has_land?
    !!land_area
  end
  
  # TODO: Nillify blanks
  #
  def has_alt_contact?
    !(contact_phone.blank? && contact_email.blank?)
  end
  
  def for_sale?
    !!selling_price
  end
  
  def for_rent?
    RENTAL_TERM_METHODS.any? {|m| send m}
  end
  
  
  protected
  
  # TODO: If very nearby properties exist, the UI needs to give the user an opportunity to determine if one of these
  #       is the same property. Selecting it will apply the property ID to this listing.
  #       For now the mechanism doesn't exist, so we just create new properies for every listing.
  #
  def create_property
    Property.create!.listings << self unless property
  end

  def validates_presence_of_alt_contact_phone_or_email
    if specify_alt_contact && !has_alt_contact?
      errors.add(:base, "Alternate contact must have a phone number or email.")
    end
  end
  
  def validates_for_sale_or_rent
    unless for_sale? || for_rent?
      errors.add(:base, "Property must include a selling price or a rental rate.")
    end
  end
      

end
