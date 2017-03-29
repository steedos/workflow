Template.org_main.helpers
	subsReady: ->
		return Steedos.subsAddressBook.ready() and Steedos.subsSpace.ready();
	isMobile: ()->
		return Steedos.isMobile();

	isNotSync: (spaceId)->
		if Steedos.isNotSync()
			return true;
		else
			return false;

Template.org_main.onRendered ->
		if Steedos.isNotSync() == false || Steedos.isNotSync() == undefined
			toastr.error(t("contacts_organization_permission_alert"));
