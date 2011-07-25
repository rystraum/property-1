module MapsHelper
  
  def marker_json(listings)
    listings.map do |l|
      { lat: l.latitude, lng: l.longitude }
    end.to_json
  end
  
end
