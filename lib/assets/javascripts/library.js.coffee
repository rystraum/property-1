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

root.humanizeLat = (lat) ->
  if lat < 0
    "S " + lat
  else
    "N " + lat
    
root.humanizeLng = (lng) ->
  if lng < 0
    "W " + lng
  else
    "E " + lng