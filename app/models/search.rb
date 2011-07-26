class Search < ActiveRecord::Base
  belongs_to :user

  geocoded_by :address

  attr_writer :location, :bounds
  
  FLOAT_REGEX = /\d+\.?\d*/
  RENTAL_TERMS = %w[ day week month ]
  DEFAULT_PARAMS = {
    for_sale: true,
    for_rent: true,
    house: true,
    apartment: true,
    multi_unit: true,
    chalet: true,
    private_room: true,
    shared_room: true,
    land: true,
    commercial: true
  }

  after_validation :geocode, :if => :address_changed?

  def initialize(*args)
    super
    extract_bounds if @bounds
  end

  def bounds
    [[sw_lat, sw_lng], [ne_lat, ne_lng]]
  end

  def listings
    Listing.within_bounding_box(bounds)
  end


  private

  def extract_bounds
    self.sw_lat, self.sw_lng, self.ne_lat, self.ne_lng = @bounds.scan(FLOAT_REGEX).map(&:to_f)
  end

end
