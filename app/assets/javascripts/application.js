//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.8.14.custom.min
//= require_tree .


// Maps
PI_BOUNDS = new google.maps.LatLngBounds((new google.maps.LatLng(0.2032248365820488, 108.77565625)), (new google.maps.LatLng(23.669661907895083, 135.14284375)))
DEFAULT_MAP = { 
  panControl: false,
  center: [12.2,121.95],
  zoom: 6,
  minZoom: 6,
  scaleControl: true,
  streetViewControl: false
}
