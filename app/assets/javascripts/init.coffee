window.WittyCart or= {}

$(document).on 'turbolinks:before-cache', ->  
  # Destroy cached JS elements on turbolinks 'before-cache' to recreate new ones on 'load' event
	$('.toast').remove();
