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
		return Template.instance().isSearching?.get()

	selector: ->

		spaceId = Steedos.spaceId()

		is_within_user_organizations = ContactsManager.is_within_user_organizations();

		hidden_users = SteedosContacts.getHiddenUsers(spaceId)

		query = {space: spaceId, user: {$nin: hidden_users}}

		isSearching = Template.instance().isSearching?.get()
		searchingTag = Template.instance().searchingTag?.get()
		if isSearching
			searchKey = $("#contact-list-search-key").val().trim()
			unless searchKey
				return { _id: -1 }
			if is_within_user_organizations
				orgs = db.organizations.find().fetch().getProperty("_id")

				orgs_childs = SteedosDataManager.organizationRemote.find({parents: {$in: orgs}}, {
					fields: {
						_id: 1
					}
				});

				orgs = orgs.concat(orgs_childs.getProperty("_id"))

				query.organizations = {$in: orgs}
		else
			orgId = Session.get("contacts_org_mobile");
			query.organizations = {$in: [orgId]};

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
	this.isSearching = new ReactiveVar(false)
	this.searchingTag = new ReactiveVar(0) #在搜索条件变化时触发tabular的selector属性重新计算
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
		$("#contact-list-search-key").focus()

	'click .weui-icon-clear': (event, template)->
		$(event.currentTarget).addClass("empty")
		$("#contact-list-search-key").val("")
		$("#contact-list-search-key").trigger("input")
		$("#contact-list-search-key").focus()

	'click .weui-search-bar__cancel-btn': (event, template)->
		template.isSearching.set(false)
		$(event.currentTarget).closest(".contacts").removeClass("mobile-searching")
		$(event.currentTarget).closest(".weui-search-bar").removeClass("weui-search-bar_focusing")
		$("#contact-list-search-key").val("")
		$("#contact-list-search-key").trigger("input")

	'input #contact-list-search-key': (event, template)->
		searchKey = $(event.currentTarget).val().trim()
		if searchKey
			$(event.currentTarget).next(".weui-icon-clear").removeClass("empty")
		else
			$(event.currentTarget).next(".weui-icon-clear").addClass("empty")

		if arguments.callee.timer
			clearTimeout arguments.callee.timer

		doSearch = (key, template)->
			if template.isSearching.get()
				# 匹配双字节字符(包括汉字在内)
				reg = /[^x00-xff]/
				unless /[^x00-xff]/.test(key)
					if key.length < 3
						# 非汉字等双字节字符，长度小于3时不执行搜索
						return
			template.searchingTag.set(template.searchingTag.get() + 1)
			dataTable = $(".datatable-mobile-users").DataTable()
			dataTable.search(
				key
			).draw()

		if template.isSearching.get()
			arguments.callee.timer = setTimeout ()->
				doSearch searchKey, template
			, 800
		else
			doSearch searchKey, template

	'focus #contact-list-search-key': (event, template)->
		template.isSearching.set(true)
		$(event.currentTarget).next(".weui-icon-clear").addClass("empty")
		$(event.currentTarget).closest(".contacts").addClass("mobile-searching")
		$(event.currentTarget).closest(".weui-search-bar").addClass("weui-search-bar_focusing")

