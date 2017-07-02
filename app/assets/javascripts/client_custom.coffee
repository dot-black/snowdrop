ready = ->
  #Flash toast animation
  $('.toast').delay(3000).fadeOut(600);

  #Image madal
  $('.item img').click ->
    $('#myModal').css('display','block')
    $('#img01').attr('src', $(this).attr('src'))
    $('#caption').html($(this).attr('alt'))
    return
  $('.close').click ->
    $('#myModal').css('display','none')
    return

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('turbolinks:load', ready)
