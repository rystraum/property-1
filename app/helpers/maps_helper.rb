module MapsHelper
  
  def gmaps_script_tag
    "<script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>".html_safe
  end
  
  def marker_json(listings)
    listings.map do |l|
      { lat: l.latitude, lng: l.longitude }
    end.to_json
  end
  
end
