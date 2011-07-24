$.fn.googleMap = () ->
  element = $(@).get(0)
  zoomLevel = $(@).data('zoom') || 8

  if $(@).data('size')
    [width, height] = $(@).data('size').split('x')
    # $(@).css({width: Number(width), height: Number(height), background: '#fff'})

  wrapperElem = $(@).wrap('<div class="map-wrap"/>').css({background:'#fff'})
  $(@).hide() # To avoid confusing Flash Of Non-interactive Map Content

  geocoder = new google.maps.Geocoder
  geocoderParams =
    address: $(@).data('address') || "Philippines"
    region: "PH"
  results = geocoder.geocode geocoderParams, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      latlng = results[0].geometry.location

      mapOptions =
        mapTypeControl: true
        overviewMapControl: true
        zoom: zoomLevel
        center: latlng
        mapTypeId: google.maps.MapTypeId.ROADMAP

      map = new google.maps.Map(element, mapOptions)

      marker = new google.maps.Marker
        position: latlng
        map: map

      $(element).show() # Time to re-show the element