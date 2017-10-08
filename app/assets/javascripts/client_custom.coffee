$(window).on 'popstate', (e) ->
  if e.originalEvent.state != null
    $.ajax
      url: '/cart_items_count'
      success: (response) ->
        $('#cart-badge').html(response['catr_items_count'])
        return
client_ready = ->
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
  $('.phone_ukraine').mask('+(380) 00 000-00-00');

# $(document).ready(client_ready)
$(document).on('page:load', client_ready)
$(document).on('turbolinks:load', client_ready)
