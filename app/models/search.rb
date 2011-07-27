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

  after_validation :geocode, :if => :address_changed?
  validates :center, :sw_bounds, :ne_bounds, latlng: true

  def initialize(*args)
    super
    extract_bounds if @bounds
  end

  def bounds
    [sw_bounds, ne_bounds] if sw_bounds && ne_bounds
  end

  def listings
    Listing.within_bounding_box(bounds)
  end


  private

  def extract_bounds
    points = @bounds.scan(FLOAT_REGEX).map(&:to_f)
    self.sw_bounds, self.ne_bounds = points[0..1], points[2..3]
  end

end
