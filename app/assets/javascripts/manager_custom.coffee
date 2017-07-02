ready = ->
  # Ability to select table row and redirect to url in it
  $(document).on 'click', "tr.selectable-row td", ->
    unless $(this).hasClass("unselectable")
      window.location = $(this).parent().data("link")

  # Submit search form via ajax
  $("#search_query").on 'keyup', ->
    setTimeout ->
      $(".search-form").submit()
    ,1000

  # Clear search input
  $("#clear_search").on 'click', ->
    $("#search_query").val('')

  # Import bootstrap-selecr
  $('.selectpicker').selectpicker()

  #Flash toast animation
  $('.toast').delay(3000).fadeOut(600);

#Form select switch for sizes
form_select_disabler = ->
  sizes =  if $("#hiden-manager-sizes").length then jQuery.parseJSON($("#hiden-manager-sizes").val()) else null
  switch $('#manager-product-category option:selected').text()
    when "Bra"
      $('#manager-bra-sizes')
        .attr('disabled', false)
        .selectpicker('refresh')
      $('#manager-standard-sizes')
        .attr('disabled', true)
        .selectpicker("deselectAll")
        .selectpicker('refresh')
      if sizes then $('#manager-bra-sizes').selectpicker('val', sizes["bra"])
    when "Bodysuite"
      $('#manager-bra-sizes')
        .attr('disabled', false)
        .selectpicker('refresh')
      $('#manager-standard-sizes')
        .attr('disabled', false)
        .selectpicker('refresh')
      if sizes then $('#manager-bra-sizes').selectpicker('val', sizes["bra"])
      if sizes then $('#manager-standard-sizes').selectpicker('val', sizes["standard"])
    else
      $('#manager-bra-sizes')
        .attr('disabled', true)
        .selectpicker("deselectAll")
        .selectpicker('refresh')
      $('#manager-standard-sizes')
        .attr('disabled', false)
        .selectpicker('refresh')
      if sizes then $('#manager-standard-sizes').selectpicker('val', sizes["standard"])
  return

$(document).ready ready, form_select_disabler
$(document).on 'page:load', ready, form_select_disabler
$(document).on 'turbolinks:load', ready, form_select_disabler
$(document).on 'change','#manager-product-category', form_select_disabler
