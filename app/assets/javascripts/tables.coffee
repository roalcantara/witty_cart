class WittyCart.Table
  constructor: ->
    @$linkables = $(".table tr[data-href]")
    @bind()

  bind: ->
    @$linkables.on 'click', @navegate

  navegate: (e) ->
    window.location = $(this).data('href')

$(document).on 'turbolinks:load', ->
  window.WittyCart.table = new WittyCart.Table()
