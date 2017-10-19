manager_ready = ->
  # Ability to select table row and redirect to url in it
  $(document).on 'click', "tr.selectable-row td", ->
    unless $(this).hasClass("unselectable")
      window.location = $(this).parent().data("link")

  # Submit search form via ajax
  $("#search_query").on 'keyup', ->
    setTimeout ->
      $(".search-form").submit()
    ,500

  # Clear search input
  $("#clear_search").on 'click', ->
    $("#search_query").val('')

  #Flash toast animation
  $('.toast').delay(3000).fadeOut(600);

  #Image madal
  $('.manager-product-image').on 'click', ->
    $('#product-image-modal').css('display','block')
    $('#full-screen-image').attr('src', $(this).attr('src'))
    $('#caption').html($(this).attr('alt'))
    return
  $('.close').on 'click', ->
    $('#product-image-modal').css('display','none')
    return

  $('#new_product').validate
    debag: false

  $('.date-time').mask('00/00/0000 00:00')  

# $(document).ready manager_ready
$(document).on 'page:load', manager_ready
$(document).on 'turbolinks:load', manager_ready
