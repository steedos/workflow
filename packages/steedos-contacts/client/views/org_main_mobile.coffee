Template.org_main_mobile.helpers
	subsReady: ->
		return Steedos.subsAddressBook.ready() and Steedos.subsSpace.ready();

	isShowOrg: ->
		unless Steedos.isNotSync()
			return false
		#在个人联系人里不需要判断管理员的权限，在组织架构中需要判断是否有管理员权限
		if /^\/contacts\b/.test(Session.get("router-path"))
			return  true
		else if Steedos.isSpaceAdmin()
			return  true

	title: ()->
		currentOrgId = Session.get('contacts_org_mobile')
		currentOrg = db.organizations.findOne({ _id: currentOrgId })
		if currentOrg
			return currentOrg.name
		else
			return Steedos.spaceName()

	preOrgId: ()->
		currentOrgId = Session.get('contacts_org_mobile')
		currentOrg = db.organizations.findOne(currentOrgId)
		return currentOrg?.parent

	isSearching: ()->
		return Session.get("contact_list_search")

	selector: ->

		spaceId = Steedos.spaceId()

		is_within_user_organizations = ContactsManager.is_within_user_organizations();

		hidden_users = SteedosContacts.getHiddenUsers(spaceId)

		query = {space: spaceId, user: {$nin: hidden_users}}

		if !Session.get("contact_list_search")
			orgId = Session.get("contacts_org_mobile");
			query.organizations = {$in: [orgId]};
		else
			if is_within_user_organizations
				orgs = db.organizations.find().fetch().getProperty("_id")

				orgs_childs = SteedosDataManager.organizationRemote.find({parents: {$in: orgs}}, {
					fields: {
						_id: 1
					}
				});

				orgs = orgs.concat(orgs_childs.getProperty("_id"))

				query.organizations = {$in: orgs}

		query.user_accepted = true
		return query;

	selectorForOrgs: ->
		currentOrgId = Session.get('contacts_org_mobile')
		spaceId = Steedos.spaceId()
		selector = {_id: -1}
		if currentOrgId
			selector =
				space: spaceId
				parent: currentOrgId
				hidden: { $ne: true }
		else
			isWithinUserOrganizations = ContactsManager.is_within_user_organizations()
			if isWithinUserOrganizations
				userId = Meteor.userId()
				uOrgs = db.organizations.find({ space: spaceId, users: userId },fields: {parents: 1}).fetch()
				_ids = uOrgs.getProperty('_id')
				orgs = _.filter uOrgs, (org) ->
					parents = org.parents or []
					return _.intersection(parents, _ids).length < 1
				selector = { space: spaceId, _id: { $in: orgs.getProperty('_id') } }
			else
				rootOrg = db.organizations.findOne({ space: spaceId, is_company: true })
				selector = {
					space: spaceId
					parent: rootOrg?._id
					hidden: { $ne: true }
				}
		return selector

Template.org_main_mobile.onCreated ->
	spaceId = Steedos.spaceId()
	Steedos.subs["Organization"].subscribe("root_organization", spaceId)
	if Session.get('contacts_org_mobile')
		return
	this.autorun ->
		isWithinUserOrganizations = ContactsManager.is_within_user_organizations()
		unless isWithinUserOrganizations
			rootOrg = db.organizations.findOne({ space: spaceId, is_company: true })
			if rootOrg
				Session.set('contacts_org_mobile', rootOrg._id)

Template.org_main_mobile.onDestroyed ->
	Steedos.subs["Organization"].clear()

Template.org_main_mobile.onRendered ->
	unless Steedos.isNotSync()
		paths = FlowRouter.current().path.match(/\/[^\/]+/)
		if paths?.length
			rootPath = paths[0]
		else
			rootPath = "/admin"
		if rootPath == "/contacts"
			rootPath = "/contacts/books"
		FlowRouter.go rootPath
		toastr.error(t("contacts_organization_permission_alert"));

Template.org_main_mobile.events
	'click .datatable-mobile-organizations tbody tr[data-id]': (event, template)->
		Session.set('contacts_org_mobile', event.currentTarget.dataset.id)

	'click .datatable-mobile-users tbody tr[data-id]': (event, template)->
		Modal.show('steedos_contacts_space_user_info_modal', {targetId: event.currentTarget.dataset.id, isEditable: false})

	'click .btn-back': (event, template)->
		currentOrgId = Session.get('contacts_org_mobile')
		currentOrg = db.organizations.findOne(currentOrgId)
		Session.set('contacts_org_mobile', currentOrg?.parent)

	'click .weui-search-bar__label': (event, template)->
		$(event.currentTarget).closest(".contacts").addClass("mobile-searching")
		$(event.currentTarget).closest(".weui-search-bar").addClass("weui-search-bar_focusing")
		$("#contact-list-search-key").focus()

	'click .weui-icon-clear': (event, template)->
		$(event.currentTarget).addClass("empty")
		$("#contact-list-search-key").val("")
		$("#contact-list-search-key").trigger("input")
		$("#contact-list-search-key").focus()

	'click .weui-search-bar__cancel-btn': (event, template)->
		$(event.currentTarget).closest(".contacts").removeClass("mobile-searching")
		$(event.currentTarget).closest(".weui-search-bar").removeClass("weui-search-bar_focusing")
		$("#contact-list-search-key").val("")
		$("#contact-list-search-key").trigger("input")

	'input #contact-list-search-key': (event, template)->
		console.log "aaa:#{$(event.currentTarget).val()}"
		searchKey = $(event.currentTarget).val()
		if searchKey
			$(event.currentTarget).next(".weui-icon-clear").removeClass("empty")
		else
			$(event.currentTarget).next(".weui-icon-clear").addClass("empty")

		if searchKey
			Session.set("contact_list_search", true)
		else
			Session.set("contact_list_search", false)
		dataTable = $(".datatable-mobile-users").DataTable();
		dataTable.search(
			$("#contact-list-search-key").val()
		).draw()

	'focus #contact-list-search-key': (event, template)->
		$(event.currentTarget).next(".weui-icon-clear").addClass("empty")

