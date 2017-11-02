Template.workflowMenuByFlow.helpers
	inboxInstancesByCategorys: ()->
		categorys = WorkflowManager.getSpaceCategories(Session.get("spaceId"))

		getCategoryInboxInstances = (category_id)->
			inboxInstancesCount = 0

			query = {}
			query.$or = [{
				inbox_users: Meteor.userId()
			}, {
				cc_users: Meteor.userId()
			}]

			query.space = Session.get("spaceId")

			if category_id
				category_forms = db.forms.find({category: category_id}, {fields: {_id: 1}}).fetch();

				query.form = {$in: category_forms.getProperty("_id")}
			else
				category_forms = db.forms.find({
					category: {
						$in: [null, ""]
					}
				}, {fields: {_id: 1}}).fetch();

				query.form = {$in: category_forms.getProperty("_id")}

			inboxInstances = db.instances.find(query).fetch();

			inboxInstancesGroupByFlow = _.groupBy(inboxInstances, "flow");

			flowIds = _.keys(inboxInstancesGroupByFlow);

			flowIds.forEach (flowId)->
				inboxInstancesCount = inboxInstancesCount + (inboxInstancesGroupByFlow[flowId]?.length || 0)

			return inboxInstancesCount

		haveInboxCategorys = new Array()

		categorys?.forEach (category)->
			category_inbox_count = getCategoryInboxInstances(category._id)

			if category_inbox_count > 0
				category.inbox_count = category_inbox_count
				haveInboxCategorys.push(category)

		unCategory_inbox_count = getCategoryInboxInstances()

		if unCategory_inbox_count > 0
			haveInboxCategorys.push({_id: "-1", name: TAPi18n.__("workflow_no_category"), inbox_count: unCategory_inbox_count})

		return haveInboxCategorys

	data: ()->
		data = []

		inboxInstances = InstanceManager.getUserInboxInstances()

		inboxInstancesGroupBySpace = _.groupBy(inboxInstances, "space")
		spaceIds = _.keys(inboxInstancesGroupBySpace);
		spaceIds.forEach (spaceId)->
			space = db.spaces.findOne(spaceId, {fields: {name: 1}});
			space.flows = [];
			inboxInstancesGroupByFlow = _.groupBy(inboxInstancesGroupBySpace[spaceId], "flow");
			flowIds = _.keys(inboxInstancesGroupByFlow);
			flowIds.forEach (flowId)->
				flow = db.flows.findOne(flowId, {fields: {name: 1, space: 1}}) || {name: flowId};
				flow.inbox_count = inboxInstancesGroupByFlow[flowId]?.length;
				space.flows.push(flow);

			data.push(space);
		return data

	boxActive: (box)->
		if box == Session.get("box")
			return "weui-bar__item_on"

	isInbox: ()->
		return Session.get("box") == "inbox"

	isSelected: (flowId)->
		if Session.get("flowId") == flowId
			return "selected"

	maxHeight: ->
		return Template.instance().maxHeight.get() - 51 + 'px'

	showNavbar: ->
#        return Steedos.isMobile()
		return false;

	Session_category: ()->
		return Session.get("workflowCategory")

Template.workflowMenuByFlow.events
	'click .weui-navbar__item': (event, template)->
		box = event.currentTarget.dataset?.box

		FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + box + "/");

	'click .menu-inbox-category': (event, template)->
		Session.set("flowId", false)
		Session.set("workflowCategory",this._id || "-1")

Template.workflowMenuByFlow.onCreated ->
	self = this;

	self.maxHeight = new ReactiveVar(
		$(window).height());

	$(window).resize ->
		self.maxHeight?.set($(".instance-list", $(".steedos")).height());


Template.workflowMenuByFlow.onRendered ->
	self = this;

	self.maxHeight?.set($(".instance-list", $(".steedos")).height());