class WittyCart.Cart
  constructor: ->
    @$modal = $('.modal.price-changed')
    @bind()

  bind: ->
    @displayModal() unless @$modal.length == 0

  displayModal: (e) =>
    $('.modal.price-changed').modal 'show'

$(document).on 'turbolinks:load', ->
  window.WittyCart.cart = new WittyCart.Cart()
