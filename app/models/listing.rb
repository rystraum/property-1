class Listing < ActiveRecord::Base
  
  include FormHelpers

  nilify_blanks
  geocoded_by :address
  
  belongs_to :user
  belongs_to :property
 
  RENTAL_TERM_ATTRIBUTES = [:rent_per_day, :rent_per_week, :rent_per_month, :rent_per_month_biannual_contract, :rent_per_month_annual_contract]
  FOR_RENT_SQL = Listing::RENTAL_TERM_ATTRIBUTES.map{ |a| "(#{a} IS NOT NULL)"}.join(' OR ')
  NOT_FOR_RENT_SQL = Listing::RENTAL_TERM_ATTRIBUTES.map{ |a| "(#{a} IS NULL)"}.join(' OR ')
  
  RESIDENCE_CONSTRUCTIONS = {
    'native'  => 'Native materials', 
    'basic'   => 'Basic materials', 
    'modern'  => 'Modern construction', 
    'elegant' => 'Elegant'
  }
  RESIDENCE_TYPES = {
    'house'        => "House",
    'apartment'    => "Apartment or condo", 
    'chalet'       => "Chalet or cabin", 
    'private_room' => "Private room",
    'shared_room'  => "Shared room"
  }
  REQUIRED_RESIDENCE_ATTRIBUTES = [:residence_type, :residence_construction, :residence_area]
  REQUIRED_LAND_ATTRIBUTES = [:land_area]

  validates_presence_of :user, :latitude, :longitude
  validates_presence_of :property, on: :update
  # TODO: Renable.  Currently disabled for dev without net access.
  # Also, this shouldn't give UI error because this is not something the user controls.  It
  # should either raise an exception, or log an error.  Probably raise, because logic is
  # broken if zoom not included.
  # validates_numericality_of :zoom, only_integer: true, greater_than: 0

  with_options allow_blank: :true do |v|
    v.validates_inclusion_of :residence_construction, in: RESIDENCE_CONSTRUCTIONS.keys
    v.validates_inclusion_of :residence_type, in: RESIDENCE_TYPES.keys
    v.validates_numericality_of :land_area, :residence_area, greater_than: 0
    v.validates_numericality_of *RENTAL_TERM_ATTRIBUTES, :selling_price, integer_only: true, greater_than: 0
  end
  
  validate :validates_presence_of_a_category
  validate :validates_presence_of_category_required_attributes 
  validate :validates_for_sale_or_rent
  validate :validates_presence_of_alt_contact_phone_or_email
  validate :validates_format_of_latitude
  validate :validates_format_of_longitude
  
  after_create :create_property_if_none_found
  after_destroy :destroy_property_if_last_listing
  
  scope :for_sale, where('selling_price IS NOT NULL')
  scope :for_rent, where(FOR_RENT_SQL)
  scope :not_for_rent, where(NOT_FOR_RENT_SQL)
  scope :exclude_land, where('residence_type IS NOT NULL')
  

  # For form handling.
  #
  attr_writer :includes_residence_values, :includes_land_values, :includes_alt_contact_values, :save_address
  
  def includes_alt_contact_values
    check_box_checked?(@includes_alt_contact_values) || has_alt_contact?
  end
  
  def includes_residence_values
    check_box_checked?(@includes_residence_values) || REQUIRED_RESIDENCE_ATTRIBUTES.any? { |a| send a }
  end
  
  def includes_land_values
    check_box_checked?(@includes_land_values) || REQUIRED_LAND_ATTRIBUTES.any? { |a| send a }
  end
  
  def save_address
    address.present?
  end
  
  ###
  
  def latitude=(value)
    self[:latitude] = extract_coordinate(value)
  end

  def longitude=(value)
    self[:longitude] = extract_coordinate(value)
  end
      
  
  # TEST
  def has_residence?
    includes_residence_values
  end
  
  # TEST
  def has_land?
    includes_land_values
  end
  
  def has_alt_contact?
    !!(contact_phone || contact_email)
  end
  
  def for_sale?
    !!selling_price
  end
  
  def for_rent?
    RENTAL_TERM_ATTRIBUTES.any? {|m| send m}
  end
  
  def geocoded?
    !!(latitude && longitude)
  end
  

  protected

  def validates_presence_of_category_required_attributes
    validates_presence_of_required_residence_attributes if has_residence?
    validates_presence_of_required_land_attributes if has_land?
  end
  
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
  
  def validates_presence_of_a_category
    unless includes_residence_values || includes_land_values
      errors.add(:base, "Listing must include a residence or land.")
    end
  end
  
  def validates_presence_of_required_residence_attributes
    REQUIRED_RESIDENCE_ATTRIBUTES.each do |a|
      errors.add(a, "is required for a residence listing.") if send(a).blank?
    end
  end
  
  def validates_presence_of_required_land_attributes
    REQUIRED_LAND_ATTRIBUTES.each do |a|
      errors.add(a, "is required for a land listing.") if send(a).blank?
    end
  end

  def validates_format_of_latitude
    if latitude.is_a? String
      unless latitude =~ Geo::CARDINAL_&_NUMBER_LATITUDE_REGEX
        errors.add(:latitude, "must be formatted like this N 10.0") 
      else
        lng = extract_float(latitude)
        errors.add(:latitude, "is invalid") unless 0 <= lng and lng <= 90
      end
    else
      errors.add(:latitude, "is invalid") unless latitude.is_a?(Numeric) and -90 < latitude and latitude < 90
    end
  end

  def validates_format_of_longitude
    if longitude.is_a? String
      unless longitude =~ Geo::CARDINAL_&_NUMBER_LONGITUDE_REGEX 
        errors.add(:longitude, "must be formatted like this: E 120.1")
      else
        lng = extract_float(longitude) 
        errors.add(:longitude, "is invalid") unless 0 <= lng and lng <= 180
      end
    else
      errors.add(:longitude, "is invalid") unless longitude.is_a?(Numeric) and -180 < longitude and longitude < 180
    end
  end

  def extract_float(string)
    string.scan(/\d+\.?\d*/).first.to_f
  end

  def extract_coordinate(value)
    if value.is_a? String
      num = extract_float(value)
      value =~ /[WwSs]/ ? -num : num
    else
      value
    end
  end
end
