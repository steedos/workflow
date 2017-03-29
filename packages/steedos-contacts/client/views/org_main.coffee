Template.org_main.helpers
	subsReady: ->
		return Steedos.subsAddressBook.ready() and Steedos.subsSpace.ready();

Template.org_main.onRendered ->
		unless Steedos.isNotSync()
			debugger
			paths = FlowRouter.current().path.match(/\/[^\/]+/)
			if paths?.length
				rootPath = paths[0]
			else
				rootPath = "/admin"
			if rootPath == "/contacts"
				rootPath = "/contacts/books"
			FlowRouter.go rootPath
			toastr.error(t("contacts_organization_permission_alert"));
				
