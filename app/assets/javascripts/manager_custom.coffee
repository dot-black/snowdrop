# ready = ->
#
#   $('#orders-table tr').click ->
#     link = $(this).data('href')
#     $.ajax
#       url: link,
#       type: "GET",
#       success: (data, textStatus, jqXHR) ->
#     return
#
# $(document).ready(ready)
# $(document).on('page:load', ready)
