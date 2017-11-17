class WittyCart.Theme
  constructor: ->
    @$tooltips = $('[rel="tooltip"],[data-rel="tooltip"]')
    @$popovers = $('[rel="popover"],[data-rel="popover"],[data-toggle="popover"]')
    @$navigation = $('nav > ul.nav')
    @$navbarToggler = $('.navbar-toggler')
    @$sidebarCloser = $('.sidebar-close')
    @$goToTop = $('a[href="#"][data-top!=true]')
    @$cardActions = $('.card-actions a')
    @$panelIconOpened = 'icon-arrow-up'
    @$panelIconClosed = 'icon-arrow-down'
    ## -------------- Default colours -------------- ##
    @$brandPrimary = '#20a8d8'
    @$brandSuccess = '#4dbd74'
    @$brandInfo = '#63c2de'
    @$brandWarning = '#f8cb00'
    @$brandDanger = '#f86c6b'
    @$grayDark = '#2a2c36'
    @$gray = '#55595c'
    @$grayLight = '#818a91'
    @$grayLighter = '#d1d4d7'
    @$grayLightest = '#f8f9fa'
    'use strict'
    @bind()

  bind: ->
    @initTooltips()
    @initPopovers()
    @initNavigation()
    @$navigation.on 'click', 'a', @clickNavigation
    @$navbarToggler.on 'click', @togglerNavbar
    @$sidebarCloser.on 'click', @closeSidebar
    @$goToTop.on 'click', @preventDefault
    @$cardActions.on 'click', @clickCardActions

  ## -------------- Initializers -------------- ##
  initTooltips: ->
    $('[rel="tooltip"],[data-rel="tooltip"]').tooltip
      'placement': 'bottom'
      delay:
        show: 400
        hide: 200
  initPopovers: ->
    @$popovers.popover()
  initNavigation: ->
    @$navigation.find('a').each ->
      cUrl = String(window.location).split('?')[0]
      if cUrl.substr(cUrl.length - 1) == '#'
        cUrl = cUrl.slice(0, -1)
      if $($(this))[0].href == cUrl
        $(this).addClass 'active'
        $(this).parents('ul').add(this).each ->
          $(this).parent().addClass 'open'
          return

  ## -------------- Events -------------- ##
  clickNavigation: (e)->
    e.preventDefault() if $.ajaxLoad
    if $(this).hasClass('nav-dropdown-toggle')
      $(this).parent().toggleClass 'open'
      WittyCart.theme.resizeBroadcast()
  togglerNavbar: (e) ->
    if $(this).hasClass('sidebar-toggler')
      $('body').toggleClass 'sidebar-hidden'
      WittyCart.theme.resizeBroadcast()
    if $(this).hasClass('sidebar-minimizer')
      $('body').toggleClass 'sidebar-minimized'
      WittyCart.theme.resizeBroadcast()
    if $(this).hasClass('aside-menu-toggler')
      $('body').toggleClass 'aside-menu-hidden'
      WittyCart.theme.resizeBroadcast()
    if $(this).hasClass('mobile-sidebar-toggler')
      $('body').toggleClass 'sidebar-mobile-show'
      WittyCart.theme.resizeBroadcast()
  closeSidebar: (e)->
    $('body').toggleClass('sidebar-opened').parent().toggleClass 'sidebar-opened'
  clickCardActions: (e)->
    if $(this).hasClass('btn-close')
      e.preventDefault()
      $(this).parent().parent().parent().fadeOut()
    else if $(this).hasClass('btn-minimize')
      e.preventDefault()
      $target = $(this).parent().parent().next('.card-block')
      if !$(this).hasClass('collapsed')
        $('i', $(this)).removeClass($.panelIconOpened).addClass $.panelIconClosed
      else
        $('i', $(this)).removeClass($.panelIconClosed).addClass $.panelIconOpened
    else if $(this).hasClass('btn-setting')
      e.preventDefault()
      $('#myModal').modal 'show'

  ## -------------- Utils -------------- ##
  capitalizeFirstLetter: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)
  resizeBroadcast: ->
    timesRun = 0
    interval = setInterval((->
      timesRun += 1
      if timesRun == 5
        clearInterval interval
      window.dispatchEvent new Event('resize')
      return
    ), 62.5)
  preventDefault: (e)->
    e.preventDefault()

$(document).on 'turbolinks:load', ->
  window.WittyCart.theme = new WittyCart.Theme()
