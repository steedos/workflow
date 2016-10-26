Template.org_main.helpers
	subsReady: ->
		return Steedos.subsAddressBook.ready() and Steedos.subsSpace.ready();