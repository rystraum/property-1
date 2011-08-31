$('#search_address').autocomplete
  source: (request, response) ->
    $('#map_canvas').gmap3
      action: 'getAddress'
      address: request.term + ', Philippines'
      callback: (results) ->
        # TODO: Some general results like 'Visayas' don't have bounds. Gmaps still maps these
        #       results and so should we, but how?  Until this is solved, we don't handle results
        #       with no bounds.
        return unless results and results[0].geometry.bounds
        response $.map results, (item) ->
          label:  item.formatted_address
          value: item.formatted_address
          center: item.geometry.location
          bounds: item.geometry.bounds
  select: (event, ui) ->
    $('#no_results').html ""
    $('#map_canvas').gmap3
      action: 'fitBounds'
      args: [ui.item.bounds]
$('#go_search_address').click ->
  $('#map_canvas').gmap3
    action: 'getAddress'
    address: $('#search_address').val() + ', Philippines'
    callback: (results) ->
      bounds = results[0].geometry.bounds if results
      if bounds
        $('#no_results').html ""
        $(@).gmap3
          action: 'fitBounds'
          args: [bounds]
        $('#search_bounds').val bounds
      else
        flashInlineError $('#new_search .error_container'), "No place or address found."
        $(@).gmap3
          action: 'fitBounds'
          args: [PI_BOUNDS]

$('#find_listing').submit ->
  window.location.href = "/listings/" + $('#listing_id').val().trim()
  false
      
$("#new_search input, select").change ->
  $(this).parents('form:first').submit()
