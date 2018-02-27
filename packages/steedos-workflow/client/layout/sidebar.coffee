Template.workflowSidebar.helpers

	spaceId: ->
		return Steedos.getSpaceId()

	boxName: ->
		if Session.get("box")
			return t(Session.get("box"))

	boxActive: (box)->
		if box == Session.get("box")
			return "active"

	hasInbox: ()->
		query = {}
		query.$or = [{
			inbox_users: Meteor.userId()
		}, {
			cc_users: Meteor.userId()
		}]

		query.space = Session.get("spaceId")

		inboxInstances = db.instances.find(query).fetch();

		return inboxInstances.length > 0

	inboxCategory: (category_id)->


		inboxInstancesFlow = []

		category = db.categories.findOne({_id: category_id})

		if category_id
			category_forms = db.forms.find({category: category_id}, {fields: {_id:1}}).fetch();
		else
			category_forms = db.forms.find({category: {
				$in: [null, ""]
			}}, {fields: {_id:1}}).fetch();

		category_flows = db.flows.find({form: {$in: category_forms.getProperty("_id")}})

		category_inbox_count = 0

		flow_instances = db.flow_instances.findOne(Steedos.getSpaceId())

		category_flows.forEach (flow)->
			flow_instance = _.find(flow_instances.flows, (_f)->
				return _f._id == flow._id
			)

			flow.inbox_count = flow_instance?.count || 0

			if flow.inbox_count > 0

				category_inbox_count = category_inbox_count + flow.inbox_count

				inboxInstancesFlow.push(flow)

		return {_id: category_id, name: category?.name, inbox_count: category_inbox_count, inboxInstancesFlow: inboxInstancesFlow}

	isShowMonitorBox: ()->
		if Meteor.settings.public?.workflow?.onlyFlowAdminsShowMonitorBox
			space = db.spaces.findOne(Session.get("spaceId"))
			if !space
				return false

			if space.admins?.includes(Meteor.userId())
				return true
			else
				flow_ids = WorkflowManager.getMyAdminOrMonitorFlows()
				if _.isEmpty(flow_ids)
					return false
				else
					return true

		return true

	draftCount: ()->
		spaceId = Steedos.spaceId()
		userId = Meteor.userId()
		return db.instances.find({state:"draft",space:spaceId,submitter:userId,$or:[{inbox_users: {$exists:false}}, {inbox_users: []}]}).count()

	selected_flow: ()->
		return Session.get("flowId")

	inboxSpaces: ()->
		return db.steedos_keyvalues.find({key: "badge"}).fetch().filter (_item)->
			if _item?.value["workflow"] > 0 && _item.space && _item.space != Session.get("spaceId")
				if db.spaces.findOne({_id: _item.space})
					return _item

	spaceName: (_id)->
		return db.spaces.findOne({_id: _id})?.name

	showOthenInbox: (inboxSpaces)->
		return inboxSpaces.length > 0

	categorys: ()->
		return WorkflowManager.getSpaceCategories(Session.get("spaceId"))

	hasInstances: (inbox_count)->
		return inbox_count > 0

	Session_category: ()->
		return Session.get("workflowCategory")

Template.workflowSidebar.events

	'click .instance_new': (event, template)->
		event.stopPropagation()
		event.preventDefault()
		#判断是否为欠费工作区
		if WorkflowManager.isArrearageSpace()
			toastr.error(t("spaces_isarrearageSpace"))
			return;

		Modal.show("flow_list_box_modal")

	'click .main-header .logo': (event) ->
		Modal.show "app_list_box_modal"

	'click .inbox-flow': (event, template)->
		Session.set("flowId", this?._id);

	'click .inbox>a,.outbox,.monitor,.draft,.pending,.completed': (event, template)->
		# 切换箱子的时候清空搜索条件
		$("#instance_search_tip_close_btn").click()

	'click .inbox>a': (event, template)->
		event.preventDefault()
		inboxUrl = $(event.currentTarget).attr("href")
		Session.set("workflowCategory", undefined)
		FlowRouter.go inboxUrl
		if Steedos.isMobile()
			# 移动端不要触发展开折叠菜单
			event.stopPropagation()

	'click .workflow-category>a': (event, template)->
		inboxUrl = $(event.currentTarget).attr("href")
		Session.set("flowId", false)
		Session.set("workflowCategory",this._id || "-1")
		FlowRouter.go inboxUrl

	'click .header-app': (event) ->
		FlowRouter.go "/workflow/"
		if Steedos.isMobile()
			# 手机上可能菜单展开了，需要额外收起来
			$("body").removeClass("sidebar-open")
