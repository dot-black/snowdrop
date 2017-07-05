ready = ->
  #Flash toast animation
  $('.toast').delay(3000).fadeOut(600);

  #Image madal
  $('.item img').click ->
    $('#product-image-modal').css('display','block')
    $('#full-screen-image').attr('src', $(this).attr('src'))
    $('#caption').html($(this).attr('alt'))
    return
  $('.close').click ->
    $('#product-image-modal').css('display','none')
    return

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('turbolinks:load', ready)
