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
    land: true,
    commercial: true
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
    center: [12.2,121.95],
    zoom: 6,
    for_sale: true,
    for_rent: true,
    house: true,
    apartment: true,
    chalet: true,
    private_room: true,
    shared_room: true,
    land: true,
    commercial: true
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
    Listing.within_bounding_box(bounds)
  end
  
  def map_options
    params = attributes.select{ |k,v| %w[ center zoom ].include?(k) && v }
    DEFAULT_MAP.merge(params).to_json
  end
  
end
