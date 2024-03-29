  #### Map config
  
  maxZoomService = new google.maps.MaxZoomService()
  geocoder = new google.maps.Geocoder

  lat = $('#listing_latitude').val() || MAP_DEFAULT_CENTER_LAT
  lng = $('#listing_longitude').val() || MAP_DEFAULT_CENTER_LNG
  center = new google.maps.LatLng(lat, lng)

  mapOptions = 
    mapTypeId: google.maps.MapTypeId.HYBRID
    panControl: true
    center: center
    zoom: Number($('#listing_zoom').val()) || MAP_MIN_ZOOM
    minZoom: MAP_MIN_ZOOM 
    scaleControl: true
    streetViewControl: false
  map = new google.maps.Map($('#map_canvas')[0], mapOptions)

  marker = new google.maps.Marker
    map: map
    position: center

  
  #### Map events
  
  google.maps.event.addListener map, 'idle', ->
    $('#listing_latitude').val humanizeLat(marker.getPosition().lat().toFixed(5))
    $('#listing_longitude').val humanizeLng(marker.getPosition().lng().toFixed(5))
    $('#listing_zoom').val map.getZoom() 
  
  google.maps.event.addListener map, 'click', (e) ->
    mapZoom = map.getZoom()
    setTimeout (->
      if mapZoom == map.getZoom()
        marker.setPosition e.latLng
        map.panTo e.latLng 
    ), 180


  #### Map geocoding responses
  
  $('#listing_address').autocomplete
    source: (request, response) ->
      geocoder.geocode {
        address: request.term + '; Philippines'
      }, (results, status) ->
        if status == "OK"
          response $.map results, (item) ->
            label: item.formatted_address
            value: item.formatted_address
            bounds: item.geometry.bounds
    open: ->
      $('.ui-menu').width(200) 
    select: (e, ui) ->
      bounds = new google.maps.LatLngBounds()
      map.fitBounds ui.item.bounds
      marker.setPosition map.getCenter()


  $('#address_zoom').click ->
    geocoder.geocode {
        address: $('#listing_address').val().replace(/\n/, ";") + '; Philippines' 
      }, (results, status) ->
        if status == "OK"
          bounds = new google.maps.LatLngBounds()
          bounds = results[0].geometry.bounds
        if bounds
          map.fitBounds bounds
          marker.setPosition map.getCenter()
        else
          flashInlineError $('#address .error_container'), "We couldn't find this location."
    return false
    
  
  $('#position_zoom').click ->
    if latLng = convertLatLng $('#listing_latitude').val(), $('#listing_longitude').val()
      latLng = new google.maps.LatLng(latLng[0], latLng[1])
      maxZoomService.getMaxZoomAtLatLng latLng, (response) ->
        if response.status == google.maps.MaxZoomStatus.OK
          map.panTo latLng
          map.setZoom response.zoom
          marker.setPosition latLng
        else
          return false
    else
      flashInlineError $('#position .error_container'), "This is not a valid position."
    return false
  
  
  #### Form Element Selection
  
  $('#listing_includes_alt_contact_values').toggleCheckedElements $('#contact_fields')
  $('#listing_includes_residence_values').toggleCheckedElements $('#residence_fields fieldset')
  $('#listing_includes_land_values').toggleCheckedElements $('#land_fields fieldset')
  

  listAsLandCheck = ->
    if $('#listing_includes_residence_values').is(':checked') and $('#listing_includes_land_values').is(':checked')
      $('#list_as_land').enable()
    else
      $('#list_as_land').disable()
  listAsLandCheck()
  $('#listing_includes_residence_values, #listing_includes_land_values').click ->
    listAsLandCheck()
  

  #### ####
