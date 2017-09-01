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

	data: ->
		return {isDisabled: true}

	getOrgName: ()->
		return SteedosDataManager.organizationRemote.findOne({_id:Session.get("contacts_orgId")},{fields:{name: 1}})?.name;

	selector: ->

		is_within_user_organizations = ContactsManager.is_within_user_organizations();

		hidden_users = Meteor.settings.public?.contacts?.hidden_users || []

		setting = db.space_settings.findOne({space: Session.get("spaceId"), key: "contacts_hidden_users"})

		setting_hidden_users = setting?.values || []

		hidden_users = hidden_users.concat(setting_hidden_users)

		query = {space: Session.get("spaceId"), user: {$nin: hidden_users}}

		if !Session.get("contact_list_search")
			console.log "contact_list_search----------yes"
			orgId = Session.get("contacts_org_mobile");
			console.log "orgId:#{orgId}"
			query.organizations = {$in: [orgId]};
		else
			console.log "contact_list_search----------no"
			console.log "is_within_user_organizations#{is_within_user_organizations}"
			if is_within_user_organizations
				orgs = db.organizations.find().fetch().getProperty("_id")
			
			console.log "orgs#{orgs}"

			console.log "Session.get(--)#{Session.get('contacts_org_mobile')}"
			if Session.get("contacts_org_mobile")
				orgs = [Session.get("contacts_org_mobile")]

			orgs_childs = SteedosDataManager.organizationRemote.find({parents: {$in: orgs}}, {
				fields: {
					_id: 1
				}
			});

			orgs = orgs.concat(orgs_childs.getProperty("_id"))

			query.organizations = {$in: orgs};

		if !Session.get('contacts_is_org_admin')
			query.user_accepted = true
		console.log "query:#{JSON.stringify query}",query
		return query;

	selectorForOrgs: ->
		currentOrgId = Session.get('contacts_org_mobile')
		spaceId = Steedos.spaceId()
		if currentOrgId
			selector =
				space: spaceId,
				parent: currentOrgId,
				hidden: { $ne: true }
		else
			isWithinUserOrganizations = ContactsManager.is_within_user_organizations();
			if isWithinUserOrganizations
				userId = Meteor.userId()
				uOrgs = db.organizations.find({ space: spaceId, users: userId },fields: {parents: 1}).fetch()
				_ids = uOrgs.getProperty('_id')
				orgs = _.filter uOrgs, (org) ->
					parents = org.parents or []
					return _.intersection(parents, _ids).length < 1
				selector = { space: spaceId, _id: { $in: orgs.getProperty('_id') } }
			else
				selector = { space: spaceId, is_company: true }
		return selector

Template.org_main_mobile.onCreated ->
	spaceId = Steedos.spaceId()
	isWithinUserOrganizations = ContactsManager.is_within_user_organizations()
	unless isWithinUserOrganizations
		rootOrg = db.organizations.findOne({ space: spaceId, is_company: true })
		if rootOrg
			Session.set('contacts_org_mobile', rootOrg._id)

Template.org_main_mobile.onRendered ->
		if Steedos.isNotSync()
			TabularTables.steedosContactsOrganizations.customData = @data
			TabularTables.steedosContactsBooks.customData = @data
			
			ContactsManager.setContactModalValue(@data.defaultValues);

			ContactsManager.handerContactModalValueLabel();
			$("#contact_list_load").hide();
		else
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
		# Modal.show('steedos_contacts_space_user_info_modal', {targetId: event.currentTarget.dataset.id, isEditable: false})