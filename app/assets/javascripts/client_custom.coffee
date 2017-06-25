ready = ->
  #Flash toast animation
  $('.toast').delay(3000).fadeOut(600);


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('turbolinks:load', ready)
