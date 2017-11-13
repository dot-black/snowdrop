class Page
  controller: () =>
    $('meta[name=page_spesific_javascript]').attr('controller')
  action: () =>
    $('meta[name=page_spesific_javascript]').attr('action')
  locale: () =>
    $('meta[name=page_spesific_javascript]').attr('locale')
@page = new Page

$(document).on 'turbolinks:load', ->
  return unless page.controller() == 'dashboard' && page.action() == 'index'
  $.ajax
    url: "/#{page.locale()}/manager/chart_statistics"
    success: (response) ->
      Morris.Line   #Dashboard orders line-chart
        element: 'morris-line-chart-orders'
        data: response.line.orders
        xkey: 'x'
        ykeys: 'y'
        xLabelFormat: (date) ->
          "#{date.getDate()} #{response.line.month_names[date.getMonth() + 1]}"
        labels: response.line.label
        hideHover: 'auto'
        resize: true
        lineColors: [ '#54cdb4' ]

      Morris.Donut #Dashboard categories donut-chart
        element: 'morris-donut-chart-categories'
        data: response.donut.category
        resize: true
        colors: response.donut.colors

      Morris.Donut #Dashboard sizes donut-chart
        element: 'morris-donut-chart-sizes'
        data: response.donut.size
        resize: true
        colors: response.donut.colors
