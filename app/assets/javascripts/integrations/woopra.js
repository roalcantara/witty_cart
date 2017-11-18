$(document).on('turbolinks:load', function() {
  (->
    t = undefined
    i = undefined
    e = undefined
    n = window
    o = document
    a = arguments
    s = 'script'
    r = [
      'config'
      'track'
      'identify'
      'visit'
      'push'
      'call'
      'trackForm'
      'trackClick'
    ]

    c = ->
      `var t`
      `var i`
      t = undefined
      i = this
      i._e = []
      t = 0
      while r.length > t
        ((t) ->

          i[t] = ->
            i._e.push([ t ].concat(Array::slice.call(arguments, 0)))
            i

          return
        ) r[t]
        t++
      return

    n._w = n._w or {}
    t = 0
    while a.length > t
      n._w[a[t]] = n[a[t]] = n[a[t]] or new c
      t++
    i = o.createElement(s)
    i.async = 1
    i.src = '//static.woopra.com/js/w.js'
    e = o.getElementsByTagName(s)[0]
    e.parentNode.insertBefore(i, e)
    return
  ) 'woopra'
  woopra.config domain: WittyCart.env.woopraDomain()
  woopra.track()
});
