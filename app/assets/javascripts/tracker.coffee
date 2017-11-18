class WittyCart.Tracker
  track: (eventName, properties = {}) ->
    return unless WittyCart.env.tracking()
    woopra.track eventName, properties

$(document).on 'turbolinks:load', ->
  window.WittyCart.tracker = new WittyCart.Tracker()
