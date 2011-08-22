class Search < ActiveRecord::Base
  belongs_to :user
  
  nilify_blanks
  geocoded_by :address

  attr_writer :location, :bounds
  [ :center, :sw_bounds, :ne_bounds ].each{ |a| serialize a, Array }
  
  FLOAT_REGEX = /-?\d+\.?\d*/
  RENTAL_TERMS = %w[ day week month ]
  DEFAULT_PARAMS = {
    for_sale: true,
    for_rent: true,
    house: true,
    apartment: true,
    chalet: true,
    private_room: true,
    shared_room: true,
    land: true
  }
  DEFAULT_MAP = { 
    panControl: false,
    center: [12.2,121.95],
    zoom: 6,
    minZoom: 6,
    scaleControl: true,
    streetViewControl: false
  }
  DEFAULT_SEARCH = {
    bounds: [[6.2384055513847985, 115.35820312500005], [18.03054453518336, 128.54179687500005]],
    center: [12.2,121.95],
    for_sale: true,
    for_rent: true,
    house: true,
    apartment: true,
    chalet: true,
    private_room: true,
    shared_room: true,
    land: true
  }

  after_validation :geocode, :if => :address_changed?
  validates :center, :sw_bounds, :ne_bounds, latlng: true

  def initialize(*args)
    super
    self.sw_bounds, self.ne_bounds = @bounds if @bounds
  end

  # TODO: Don't need to store bounds?

  # TODO: This doesn't belong in Search
  # Returns [[lat1, lng1], [lat2, lng2], ...]
  def self.format_positions(string)
    string.scan(FLOAT_REGEX).map(&:to_f).each_slice(2).to_a
  end
  
  def bounds
    [sw_bounds, ne_bounds] if sw_bounds && ne_bounds
  end
  
  def listings
    scope = Listing.scoped
    scope = residence_type_scope(scope)
    scope = for_sale_scope(scope)
    scope = for_rent_scope(scope)
    # TODO: Add "More value as land" before implementing search functionality
    # scope = scope.where('land_area > 0') if land
    scope = scope.within_bounding_box(bounds) # if bounds
    scope
  end
  
  def map_options
    params = attributes.select{ |k,v| %w[ center zoom ].include?(k) && v }
    DEFAULT_MAP.merge(params).to_json
  end
  
  
  protected
  
  def residence_type_scope(scope)
    blacklist = Listing::RESIDENCE_TYPES.keys.delete_if{ |e| send(e) }
    scope = scope.where "residence_type IS NULL OR residence_type NOT IN (#{ blacklist.map{ |e| "'#{e}'" }.join(', ') })" unless blacklist.empty?
    scope
  end
  
  def for_sale_scope(scope)
    return scope.where(Listing.for_rent_sql) if for_rent && !for_sale
    return scope.where(selling_price: nil) unless for_sale  # Filter those not for sale
    scope = scope.where("selling_price >= ?", for_sale_min_price) if for_sale_min_price
    scope = scope.where("selling_price <= ?", for_sale_max_price) if for_sale_max_price
    scope
  end
  
  def for_rent_scope(scope)
    return scope.where("selling_price IS NOT NULL") if !for_rent && for_sale
    return scope.where(Listing.not_for_rent_sql) unless for_rent
    # TODO: Fully handle rental term
    scope = scope.where("#{rental_term} >= ?", for_rent_min_price) if for_rent_min_price
    scope = scope.where("#{rental_term} <= ?", for_rent_max_price) if for_rent_max_price
    scope
  end
  
end
