isOrgAdmin = ->
	currentOrg = Session.get('contacts_org_mobile')
	Session.set 'contacts_is_org_admin', false
	if Steedos.isSpaceAdmin()
		Session.set 'contacts_is_org_admin', true
	else
		Meteor.call 'check_org_admin', currentOrg, (error,is_suc) ->
			if error
				console.log(error)
			else
				if is_suc
					Session.set 'contacts_is_org_admin', true

spaceUsersSelector = ->
	spaceId = Steedos.spaceId()
	myLimit = Steedos.my_limit_organizations
	# hidden_users = SteedosContacts.getHiddenUsers(spaceId)
	# query = {space: spaceId, user: {$nin: hidden_users}}
	query = {space: spaceId}
	isSearching = Session.get "contact_list_search"
	if isSearching
		searchingKey = Session.get('contacts_searching_key_mobile')
		unless searchingKey
			return { _id : -1}
		if myLimit?.isLimit
			orgs = db.organizations.find().fetch().getProperty("_id")
			if myLimit.organizations?.length
				orgs = _.union(orgs, myLimit.organizations)
			orgs_childs = SteedosDataManager.organizationRemote.find({parents: {$in: orgs}}, {
				fields: {
					_id: 1
				}
			});
			orgs = orgs.concat(orgs_childs.getProperty("_id"))
			query.organizations = {$in: orgs}
	else
		orgId = Session.get("contacts_org_mobile")
		query.organizations = {$in: [orgId]};

	query.user_accepted = true
	return query;

organizationsSelector = ->
	currentOrgId = Session.get('contacts_org_mobile')
	spaceId = Steedos.spaceId()
	selector = {_id: -1}
	if currentOrgId
		selector =
			space: spaceId
			parent: currentOrgId
			hidden: { $ne: true }
	else
		myLimit = Steedos.my_limit_organizations
		if myLimit?.isLimit
			userId = Meteor.userId()
			uOrgs = db.organizations.find({ space: spaceId, users: userId },fields: {parents: 1}).fetch()
			_ids = uOrgs.getProperty('_id')
			orgs = _.filter uOrgs, (org) ->
				parents = org.parents or []
				return _.intersection(parents, _ids).length < 1
			orgIds = orgs.getProperty('_id')
			if myLimit.organizations.length
				orgIds = _.union(orgIds, myLimit.organizations)
			selector = { space: spaceId, _id: { $in: orgIds } }
		else
			rootOrg = db.organizations.findOne({ space: spaceId, is_company: true })
			selector = {
				space: spaceId
				parent: rootOrg?._id
				hidden: { $ne: true }
			}
	return selector

isShowContactsUsers = ->
	usersCount = db.space_users.find(spaceUsersSelector()).count()
	organizationsCount = db.organizations.find(organizationsSelector()).count()
	if organizationsCount and !usersCount
		# 组织中有数据并且人员中没有数据时，就要隐藏人员列表，只让用户看到组织列表中的数据
		return false
	else
		return true

Template.org_main_mobile.helpers
	subsReady: ->
		return Steedos.subsAddressBook.ready() and Steedos.subsSpaceBase.ready() and Steedos.subsSpace.ready()

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

	isBackButtonNeeded: ()->
		currentOrgId = Session.get('contacts_org_mobile')
		unless currentOrgId
			return false
		currentOrg = db.organizations.findOne({ _id: currentOrgId })
		if currentOrg
			return !currentOrg.is_company
		else
			return false

	selector: ->
		return spaceUsersSelector()

	selectorForOrgs: ->
		return organizationsSelector()

	tabular_users_class: ->
		className = "table table-striped datatable-mobile-users"
		unless isShowContactsUsers()
			className += " hidden" 
		return className

	tabular_organizations_class: ->
		className = "table table-striped datatable-mobile-organizations"
		isSearching = Session.get "contact_list_search"
		if isSearching
			className += " hidden"
		return className

	orgFields: ()->
		fields =
			contacts_org_mobile_sel:
				autoform:
					type: 'selectorg'
				optional: false
				type: String
				label: ''

		return new SimpleSchema(fields)

	showAddContactUserBtn: ()->
		return Steedos.isSpaceAdmin()

	isBackToAdmin: ()->
		currentRoute = FlowRouter.current().path
		if Steedos.isMobile() and /\/admin/.test(currentRoute)
			return true
		else
			return false


Template.org_main_mobile.onCreated ->
	Session.set 'contacts_is_org_admin', false
	Session.set "contact_list_search", false
	Session.set('contacts_org_mobile',null)
	Session.set('contacts_org_mobile_root', null)
	this.autorun ->
		spaceId = Steedos.spaceId()
		if Steedos.my_limit_organizations?.isLimit
			orgs = db.organizations.find(organizationsSelector())
			organizationsCount = orgs.count()
			if organizationsCount == 1
				org = orgs.fetch()[0]
				if org.is_company
					Session.set('contacts_org_mobile', org._id)
					Session.set('contacts_org_mobile_root', org._id)
		else
			Steedos.subs["Organization"].subscribe("root_organization", spaceId)
			rootOrg = db.organizations.findOne({ space: spaceId, is_company: true })
			if rootOrg
				Session.set('contacts_org_mobile', rootOrg._id)
				Session.set('contacts_org_mobile_root', rootOrg._id)

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

	this.autorun ->
		searchingKey = Session.get('contacts_searching_key_mobile')
		if searchingKey || searchingKey == ""
			dataTable = $(".datatable-mobile-users").DataTable()
			dataTable.search(
				searchingKey
			).draw()

Template.org_main_mobile.events
	'click .contacts-wrapper-mobile .navigation-title': (event,template) ->
		$("input[name='contacts_org_mobile_sel']").click()

	'change input[name="contacts_org_mobile_sel"]':()->
		contacts_org_mobile_sel = AutoForm.getFieldValue("contacts_org_mobile_sel","contacts_org_mobile_sel_form") || null
		unless contacts_org_mobile_sel
			rootOrg = Session.get("contacts_org_mobile_root")
			contacts_org_mobile_sel = rootOrg
		Session.set('contacts_org_mobile', contacts_org_mobile_sel)
		AutoForm.resetForm("contacts_org_mobile_sel_form")

	'click .datatable-mobile-organizations tbody tr[data-id]': (event, template)->
		Session.set('contacts_org_mobile', event.currentTarget.dataset.id)

	'click .datatable-mobile-users tbody tr[data-id]': (event, template)->
		isOrgAdmin()
		Modal.show('steedos_contacts_space_user_info_modal', {targetId: event.currentTarget.dataset.id})

	'click .btn-back': (event, template)->
		currentOrgId = Session.get('contacts_org_mobile')
		newOrgId = null
		currentOrg = if currentOrgId then db.organizations.findOne(currentOrgId) else null
		if currentOrg and currentOrg.parent
			# 判断currentOrg.parent是否在当前用户可查看权限范围，如果是则直接返回，反之则返回null
			myLimit = Steedos.my_limit_organizations
			if myLimit?.isLimit
				spaceId = Steedos.spaceId()
				userId = Meteor.userId()
				uOrgs = db.organizations.find({ space: spaceId, users: userId },fields: {parents: 1}).fetch()
				_ids = uOrgs.getProperty('_id')
				if _ids.indexOf(currentOrg.parent) > -1
					newOrgId = currentOrg.parent
				else if _.intersection(currentOrg.parents, _ids).length > 0
					newOrgId = currentOrg.parent
				if myLimit.organizations.length
					# 额外有权限查看的组织也要确认下是否在范围内
					if _.intersection(currentOrg.parents, myLimit.organizations).length > 0
						newOrgId = currentOrg.parent
			else
				newOrgId = currentOrg.parent

		Session.set('contacts_org_mobile', newOrgId)
		$(".contacts-mobile .weui-search-bar__cancel-btn").trigger("click")

	'click .weui-search-bar__label': (event, template)->
		$("#contact-list-search-key").focus()

	'click .weui-icon-clear': (event, template)->
		$(event.currentTarget).addClass("empty")
		$("#contact-list-search-key").val("")
		$("#contact-list-search-key").focus()

	'click .weui-search-bar__cancel-btn': (event, template)->
		Session.set "contact_list_search", false
		$(event.currentTarget).closest(".contacts").removeClass("mobile-searching")
		$(event.currentTarget).closest(".weui-search-bar").removeClass("weui-search-bar_focusing")
		$("#contact-list-search-key").val("")
		Session.set('contacts_searching_key_mobile',"")

	'input #contact-list-search-key': (event, template)->
		searchKey = $(event.currentTarget).val().trim()
		if searchKey
			$(event.currentTarget).next(".weui-icon-clear").removeClass("empty")
		else
			$(event.currentTarget).next(".weui-icon-clear").addClass("empty")

		if arguments.callee.timer
			clearTimeout arguments.callee.timer

		if Session.get "contact_list_search"
			arguments.callee.timer = setTimeout ()->
				# 匹配双字节字符(包括汉字在内)
				reg = /[^x00-xff]/
				unless /[^x00-xff]/.test(searchKey)
					if searchKey.length < 3
						# 非汉字等双字节字符，长度小于3时不执行搜索
						return
				Session.set('contacts_searching_key_mobile',searchKey)
			, 800

	'focus #contact-list-search-key': (event, template)->
		Session.set "contact_list_search", true
		$(event.currentTarget).next(".weui-icon-clear").addClass("empty")
		$(event.currentTarget).closest(".contacts").addClass("mobile-searching")
		$(event.currentTarget).closest(".weui-search-bar").addClass("weui-search-bar_focusing")

	'click .add-contact-user': (event,template) ->
		Modal.show("steedos_contacts_add_user_modal")

