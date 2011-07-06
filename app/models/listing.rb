class Listing < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  
  REQUIRED_RESIDENCE_ATTRIBUTES = [:residence_type, :residence_construction, :residence_area]
  RESIDENCE_CONSTRUCTIONS = ['Native materials', 'Basic materials', 'Modern construction', 'Elegant']
  RESIDENCE_TYPES = ['House', 'Duplex or other multi-unit home', 'Apartment, flat or condominium', 'Bungalow, chalet or cabin', 'Private room', 'Shared room']
  RENTAL_TERM_ATTRIBUTES = [:rent_per_day, :rent_per_week, :rent_per_month, :rent_per_month_biannual_contract, :rent_per_month_annual_contract]

  attr_writer :specify_residence, :specify_land, :specify_alt_contact

  validates_presence_of :user, :latitude, :longitude, :title
  validates_presence_of :property, on: :update

  with_options allow_blank: :true do |v|
    v.validates_inclusion_of :residence_construction, in: RESIDENCE_CONSTRUCTIONS
    v.validates_inclusion_of :residence_type, in: RESIDENCE_TYPES
    v.validates_numericality_of :land_area, :residence_area, greater_than: 0
    v.validates_numericality_of *RENTAL_TERM_ATTRIBUTES, :selling_price, integer_only: true, greater_than: 0
  end
  
  validate :validates_presence_of_residence_or_land
  validate :validates_for_sale_or_rent
  validate :validates_presence_of_alt_contact_phone_or_email
  validate :validates_presence_of_required_residence_fields
  
  after_create :create_property_if_none_found
  after_destroy :destroy_property_if_last_listing
  
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
    RENTAL_TERM_ATTRIBUTES.any? {|m| send m}
  end
  
  
  protected
  
  # TODO: If very nearby properties exist, the UI needs to give the user an opportunity to determine if one of these
  #       is the same property. Selecting it will apply the property ID to this listing.
  #       For now the mechanism doesn't exist, so we just create new properies for every listing.
  #
  def create_property_if_none_found
    Property.create!.listings << self unless property
  end
  
  def destroy_property_if_last_listing
    property.destroy if property.listings.count == 0
  end

  def validates_presence_of_alt_contact_phone_or_email
    if specify_alt_contact && !has_alt_contact?
      errors.add(:base, "Alternate contact must have a phone number or email.")
    end
  end
  
  def validates_for_sale_or_rent
    unless for_sale? || for_rent?
      errors.add(:base, "Listing must include a selling price or a rental rate.")
    end
  end
  
  def validates_presence_of_residence_or_land
    unless has_residence? || has_land?
      errors.add(:base, "Listing must include a residence or land.")
    end
  end
  
  def validates_presence_of_required_residence_fields
    return unless @specify_residence
    REQUIRED_RESIDENCE_ATTRIBUTES.each do |attr|
      errors.add(attr, "is required for a residence listing.")
    end
  end

end
