$ = jQuery
root = global ? window

# Disable inputs and add .disabled class to non-inputs.
$.fn.disable = ->
  $(':input', @).attr("disabled", true)
  $(':not(:input)', @).add($(@)).addClass('disabled')

# Enable inputs and remove .disabled class from non-inputs.
$.fn.enable = ->
  $(':input', @).attr("disabled", false)
  $(':not(:input)', @).add($(@)).removeClass('disabled')


# Clear form inputs.  Useful for clearing a subset of form inputs, as opposed to the
# entire form.
#
# Usage:
#
# $('some_inputs').clearInputs
#
$.fn.clearInputs = ->
  $(':input', @).val('') 
  # De-select any checkboxes, radios and drop-down menus
  $(':input', @).removeAttr('checked').removeAttr('selected')
  # Select the first option of selects
  $('select option:first', @).attr('selected', true)
 
  
# Slide toggle the appearance of some elements using a checkbox. Inputs on the toggled
# elements are cleared each time.
#
# Usage:
#
# $('#some_checkbox').toggleCheckedElements $('elements_to_toggle')
#
$.fn.toggleCheckedElements = (inputs) ->
  inputs.hide() unless $(@).attr('checked')

  $(@).click ->
    if $(@).attr('checked')
      inputs.slideDown 'fast'
    else
      inputs.slideUp 'fast'
      inputs.clearInputs()


####### GEOCODING #######


# Example: Converts: "N 23.22", "W 118.23" 
#                To: "23.22, -118.23"
#
root.convertLatLng = (lat, lng) ->
  return false unless lat.match(/^\s*[NS]\s*\d+\.?\d*\s*$/i) and lng.match(/^\s*[EW]\s*\d+\.?\d*\s*$/i)
  latValue = lat.match(/\d+\.?\d*/)[0]
  lngValue = lng.match(/\d+\.?\d*/)[0]
  return false unless (0 < latValue < 90) and (0 < lngValue < 180)
  latValue = -(latValue) if lat.match /s/i
  lngValue = -(lngValue) if lng.match /w/i
  
  [latValue, lngValue]
  
  
root.humanizeLat = (lat) ->
  if lat < 0
    lat = Math.abs lat
    "S " + lat
  else
    "N " + lat
  
    
root.humanizeLng = (lng) ->
  if lng < 0
    lng = Math.abs lng
    "W " + lng
  else
    "E " + lng
