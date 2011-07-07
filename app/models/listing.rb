class Listing < ActiveRecord::Base
  include FormHelpers
  
  belongs_to :user
  belongs_to :property
  
  REQUIRED_RESIDENCE_ATTRIBUTES = [:residence_type, :residence_construction, :residence_area]
  REQUIRED_LAND_ATTRIBUTES = [:land_area]
  RESIDENCE_CONSTRUCTIONS = ['Native materials', 'Basic materials', 'Modern construction', 'Elegant']
  RESIDENCE_TYPES = ['House', 'Duplex or other multi-unit home', 'Apartment, flat or condominium', 'Bungalow, chalet or cabin', 'Private room', 'Shared room']
  RENTAL_TERM_ATTRIBUTES = [:rent_per_day, :rent_per_week, :rent_per_month, :rent_per_month_biannual_contract, :rent_per_month_annual_contract]

  attr_writer :includes_residence_values, :includes_land_values, :includes_alt_contact_values

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
  validate :validates_presence_of_required_residence_values
  validate :validates_presence_of_required_land_values
  
  after_create :create_property_if_none_found
  after_destroy :destroy_property_if_last_listing
  
  # TODO: How to coerce AR/AM to handle this?
  # TEST!
  #
  # For form handling.
  def includes_alt_contact_values
    check_box_checked?(@includes_alt_contact_values) || has_alt_contact?
  end
  
  # TODO: Nillify blanks
  #
  def includes_residence_values
    check_box_checked?(@includes_residence_values) || REQUIRED_RESIDENCE_ATTRIBUTES.any? { |a| !send(a).blank? }
  end
  
  def includes_land_values
    check_box_checked?(@includes_land_values) || REQUIRED_LAND_ATTRIBUTES.any? { |a| !send(a).blank? }
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
    if includes_alt_contact_values && !has_alt_contact?
      errors.add(:base, "Alternate contact must have a phone number or email.")
    end
  end
  
  def validates_for_sale_or_rent
    unless for_sale? || for_rent?
      errors.add(:base, "Listing must include a selling price or a rental rate.")
    end
  end
  
  def validates_presence_of_residence_or_land
    unless includes_residence_values || includes_land_values
      errors.add(:base, "Listing must include a residence or land.")
    end
  end
  
  def validates_presence_of_required_residence_values
    return unless includes_residence_values
    REQUIRED_RESIDENCE_ATTRIBUTES.each do |attrib|
      errors.add(attrib, "is required for a residence listing.") unless !send(attrib).blank?
    end
  end
  
  def validates_presence_of_required_land_values
    return unless includes_land_values
    REQUIRED_LAND_ATTRIBUTES.each do |attrib|
      errors.add(attrib, "is required for a land listing.") unless !send(attrib).blank?
    end
  end

end
