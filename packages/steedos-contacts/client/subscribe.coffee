Steedos.subsAddressBook = new SubsManager();

Tracker.autorun (c)->
	if Meteor.userId()
		Steedos.subsAddressBook.subscribe "address_groups";

		Steedos.subsAddressBook.subscribe "address_books";


Tracker.autorun (c)->
	Session.set('contacts_is_org_admin',false)
	orgId = Session.get('contacts_orgId')
	unless orgId
		return
	if Steedos.isSpaceAdmin()
		Session.set('contacts_is_org_admin',true)
		return
	currentOrg = db.organizations.findOne(orgId)
	userId = Steedos.userId()
	if currentOrg?.admins?.includes(userId)
		Session.set('contacts_is_org_admin',true)
		return
	$("body").addClass("loading")
	console.log "calling method check_org_admin,orgId:#{orgId}"
	Meteor.call 'check_org_admin', orgId, (error, is_suc) ->
		$("body").removeClass("loading")
		if is_suc
			Session.set('contacts_is_org_admin',true)
		else if error
			console.error error
			toastr.error(t(error.reason))