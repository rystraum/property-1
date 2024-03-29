#= require jquery
#= require jquery_ujs
#= require jquery-ui-1.8.14.custom.min
#= require gmap3
#= require library

root = global ? window

# Maps
root.PI_BOUNDS = new google.maps.LatLngBounds((new google.maps.LatLng(0.2032248365820488, 108.77565625)), (new google.maps.LatLng(23.669661907895083, 135.14284375)))
root.MAP_MIN_ZOOM = 6
root.MAP_DEFAULT_CENTER_LAT = 12.2
root.MAP_DEFAULT_CENTER_LNG = 121.95

  
# Flash in an error message inside the specified container. Use in forms for js validation errors.
#
root.flashInlineError = (container, text) ->
  error = $("<div class='error'>" + text + "</div>").hide()
  $('.error', container).remove()
  container.append error
  error.fadeIn(50).delay(3000).fadeOut(200, -> $(@).remove())
