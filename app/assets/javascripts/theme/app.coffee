###****
* CONFIGURATION
###

#Main navigation

capitalizeFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

init = (url) ->

  ### ---------- Tooltip ---------- ###

  $('[rel="tooltip"],[data-rel="tooltip"]').tooltip
    'placement': 'bottom'
    delay:
      show: 400
      hide: 200

  ### ---------- Popover ---------- ###

  $('[rel="popover"],[data-rel="popover"],[data-toggle="popover"]').popover()
  return

$.navigation = $('nav > ul.nav')
$.panelIconOpened = 'icon-arrow-up'
$.panelIconClosed = 'icon-arrow-down'
#Default colours
$.brandPrimary = '#20a8d8'
$.brandSuccess = '#4dbd74'
$.brandInfo = '#63c2de'
$.brandWarning = '#f8cb00'
$.brandDanger = '#f86c6b'
$.grayDark = '#2a2c36'
$.gray = '#55595c'
$.grayLight = '#818a91'
$.grayLighter = '#d1d4d7'
$.grayLightest = '#f8f9fa'
'use strict'

###***
* MAIN NAVIGATION
###

$(document).ready ($) ->
  # Add class .active to current link

  resizeBroadcast = ->
    timesRun = 0
    interval = setInterval((->
      timesRun += 1
      if timesRun == 5
        clearInterval interval
      window.dispatchEvent new Event('resize')
      return
    ), 62.5)
    return

  $.navigation.find('a').each ->
    cUrl = String(window.location).split('?')[0]
    if cUrl.substr(cUrl.length - 1) == '#'
      cUrl = cUrl.slice(0, -1)
    if $($(this))[0].href == cUrl
      $(this).addClass 'active'
      $(this).parents('ul').add(this).each ->
        $(this).parent().addClass 'open'
        return
    return
  # Dropdown Menu
  $.navigation.on 'click', 'a', (e) ->
    if $.ajaxLoad
      e.preventDefault()
    if $(this).hasClass('nav-dropdown-toggle')
      $(this).parent().toggleClass 'open'
      resizeBroadcast()
    return

  ### ---------- Main Menu Open/Close, Min/Full ---------- ###

  $('.navbar-toggler').click ->
    if $(this).hasClass('sidebar-toggler')
      $('body').toggleClass 'sidebar-hidden'
      resizeBroadcast()
    if $(this).hasClass('sidebar-minimizer')
      $('body').toggleClass 'sidebar-minimized'
      resizeBroadcast()
    if $(this).hasClass('aside-menu-toggler')
      $('body').toggleClass 'aside-menu-hidden'
      resizeBroadcast()
    if $(this).hasClass('mobile-sidebar-toggler')
      $('body').toggleClass 'sidebar-mobile-show'
      resizeBroadcast()
    return
  $('.sidebar-close').click ->
    $('body').toggleClass('sidebar-opened').parent().toggleClass 'sidebar-opened'
    return

  ### ---------- Disable moving to top ---------- ###

  $('a[href="#"][data-top!=true]').click (e) ->
    e.preventDefault()
    return
  return

###***
* CARDS ACTIONS
###

$(document).on 'click', '.card-actions a', (e) ->
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
  return
