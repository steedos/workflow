Template.dock.helpers
		

Template.dock.onRendered ->
	
	$('html').addClass "dockOnTop"

	$('.ui.dropdown').dropdown({on: 'hover'});


Template.dock.events

	"click .ui.menu a.item": ->
		$(this).addClass('active').siblings().removeClass('active')

	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"