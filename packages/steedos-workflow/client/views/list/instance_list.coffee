Template.instance_list.helpers

	instances: ->
		return db.instances.find({}, {sort: {modified: -1}});

	boxName: ->
		if Session.get("box")
			return t(Session.get("box"))

	spaceId: ->
		return Session.get("spaceId");

	hasFlowId: ->
		return !!Session.get("flowId");

	selector: ->
		unless Meteor.user()
			return {make_a_bad_selector: 1}
		query = {space: Session.get("spaceId"), flow: Session.get("flowId")}
		box = Session.get("box")
		if box == "inbox"
			query.$or = [{inbox_users: Meteor.userId()}, {cc_users: Meteor.userId()}]
			# query.state = {$in: ["pending", "completed"]}
			# query.inbox_users = Meteor.userId()
		else if box == "outbox"
			uid = Meteor.userId()
			query.$or = [{outbox_users: uid}, {$or: [{submitter: uid}, {applicant: uid}], state: "pending"}]
		else if box == "draft"
			query.submitter = Meteor.userId()
			query.state = "draft"
			query.inbox_users = {$exists:false}
		else if box == "pending"
			uid = Meteor.userId()
			query.$or = [{submitter: uid}, {applicant: uid}]
			query.state = "pending"
		else if box == "completed"
			query.submitter = Meteor.userId()
			query.state = "completed"
		else if box == "monitor"
			query.state = {$in: ["pending", "completed"]}
			uid = Meteor.userId()
			space = db.spaces.findOne(Session.get("spaceId"))
			if !space
				query.state = "none"

			if !space.admins.contains(uid)
				flow_ids = WorkflowManager.getMyAdminOrMonitorFlows()
				# if query.flow
				# 	if !flow_ids.includes(query.flow)
				# 		query.$or = [{submitter: uid}, {applicant: uid}, {inbox_users: uid}, {outbox_users: uid}]
				# else
				# 	query.$or = [{submitter: uid}, {applicant: uid}, {inbox_users: uid}, {outbox_users: uid},
				# 		{flow: {$in: flow_ids}}]
				if query.flow
					if !flow_ids.includes(query.flow)
						query.flow = ""
				else
					query.flow = {$in: flow_ids}

		else
			query.state = "none"

		query.is_deleted = false

		instance_more_search_selector = Session.get('instance_more_search_selector')
		if (instance_more_search_selector)
			_.keys(instance_more_search_selector).forEach (k)->
				query[k] = instance_more_search_selector[k]

		Template.instance_list._tableColumns()

		return query

	enabled_export: ->
		spaceId = Session.get("spaceId");
		if !spaceId
			return "display: none;";
		space = db.spaces.findOne(spaceId);
		if !space
			return "display: none;";
		if Session.get("box") == "monitor"
			if space.admins.contains(Meteor.userId())
				return "";
			else
				if Session.get("flowId")
					flow_ids = WorkflowManager.getMyAdminOrMonitorFlows()
					if flow_ids.includes(Session.get("flowId"))
						return ""
				return "display: none;";
		else
			return "display: none;";

	is_display_search_tip: ->
		if Session.get('instance_more_search_selector') or Session.get('instance_search_val') or Session.get("flowId")
			return ""
		return "display: none;"

	maxHeight: ->
		return Template.instance()?.maxHeight.get() + 'px'

	isShowMenu: ->
#		if Session.get("box") == 'inbox'
#			inboxInstances = InstanceManager.getUserInboxInstances();
#			if inboxInstances.length > 0
#				return true
#
#		return false;

		return true;

	hasApproves: ->
		if InstanceManager.getUserInboxInstances().length > 0 && Session.get("box") == "inbox"
			return true
		return false

	filterFlowName: ->
		return db.flows.findOne(Session.get("flowId"))?.name

	getInstanceListTabular: ->
		if Session.get("flowId")
			key = "instanceFlow" + Session.get("flowId")
			if TabularTables.flowInstances.get()?.name == key
				return TabularTables.flowInstances.get()
			else
				TabularTables.instances
		else
			return TabularTables.instances

Template.instance_list._tableColumns = ()->
	show = false

	winWidth = $(window).width()
	if (winWidth > 766) and (winWidth < 1441 or !$("body").hasClass("three-columns"))
		show = true

	if show
		$(".custom-column").hide();
		$(".field-value").hide();
	else
		$(".custom-column").show();
		$(".field-value").show();

	table = $(".datatable-instances").DataTable();
	thead = $("thead",$(".datatable-instances"))

	table.column(0).visible(!show)

	table.column(2).visible(show)

	columnCount = table.columns()[0]?.length || 0

	if Session.get("flowId")
		table.column(5).visible(false)
	else
		table.column(5).visible(show)
	if Session.get("box") == "draft"
		table.column(3).visible(false)
		table.column(4).visible(false)
		table.column(6).visible(false)
		table.column(7).visible(false)
		if columnCount > 9
			_.range(10, columnCount + 1).forEach (index)->
				table.column(index - 1)?.visible(false)
	else
		table.column(3).visible(show)
		table.column(4).visible(show)
		table.column(6).visible(show)
		table.column(7).visible(show)
		if columnCount > 9
			_.range(10, columnCount + 1).forEach (index)->
				table.column(index - 1)?.visible(show)


	if show
		thead.show()
	else
		thead.hide()


Template.instance_list.onCreated ->
	self = this;

	self.maxHeight = new ReactiveVar(
		$(window).height());

	$(window).resize ->
		Template.instance_list._tableColumns();
#		Session.set("tableColumns", tableColumns)

		self.maxHeight?.set($(".instance-list",$(".steedos")).height());

Template.instance_list.onRendered ->
	#dataTable = $(".datatable-instances").DataTable();
	#dataTable.select();

	self = this;

	self.maxHeight?.set($(".instance-list",$(".steedos")).height());

	Template.instance_list._tableColumns();

	$('[data-toggle="tooltip"]').tooltip()
	if !Steedos.isMobile() && !Steedos.isPad()
		$(".instance-list > div:eq(2)").addClass("dataTables_container")
		$(".instance-list").perfectScrollbar({suppressScrollX: true});
		$(".instance-list .dataTables_container").perfectScrollbar();

Template.instance_list.events

	'click tbody > tr': (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		row = $(event.target).closest('tr');
		rowData = dataTable.row(event.currentTarget).data();
		if (!rowData)
			return;
		box = Session.get("box");
		spaceId = Session.get("spaceId");

		# if row.hasClass('selected')
		# 	row.removeClass('selected');
		# 	FlowRouter.go("/workflow/space/" + spaceId + "/" + box);

		# else
		dataTable.$('tr.selected').removeClass('selected');
		row.addClass('selected');
		FlowRouter.go("/workflow/space/" + spaceId + "/" + box + "/" + rowData._id);


	'click .dropdown-menu li a': (event) ->
		InstanceManager.exportIns(event.target.type);

	'keyup #instance_search': (event) ->
		dataTable = $(".datatable-instances").DataTable();
		dataTable.search(
			$('#instance_search').val(),
		).draw();
		Session.set('instance_search_val', $('#instance_search').val())

	'click [name="show_all_ins"]': (event) ->
		Session.set("flowId", undefined);

	'click [name="create_ins_btn"]': (event) ->
		#判断是否为欠费工作区
		if WorkflowManager.isArrearageSpace()
			toastr.error(t("spaces_isarrearageSpace"));
			return;

		Modal.show("flow_list_box_modal")

	'click [name="show_flows_btn"]': (event) ->
		Modal.show('flow_list_modal')

	'click #instance_more_search': (event, template) ->
		Modal.show("instance_more_search_modal")

	'click #instance_search_tip_close_btn': (event, template) ->
		Session.set("instance_more_search_selector", undefined)
		Session.set("flowId", undefined)
		Session.set("instance-search-state",undefined)
		Session.set("instance-search-name",undefined)
		Session.set("instance-search-appplicant-name",undefined)
		Session.set("instance-search-applicant-organization-name",undefined)
		Session.set("submit-date-start",undefined);
		Session.set("submit-date-end",undefined);
		#清空搜索框
		$('#instance_search').val("").trigger('keyup')

	'click #sidebarOffcanvas': ()->
		if !Steedos.isMobile() && !Steedos.isPad()
			if !$("body").hasClass("sidebar-collapse")
				$(".treeview-menu").perfectScrollbar()
			else
				$('.treeview-menu').perfectScrollbar('destroy');

	'click .btn-toogle-columns': (event)->
		if Session.get("instanceId")
			backURL = "/workflow/space/" + Session.get("spaceId") + "/" + Session.get("box")
			FlowRouter.go(backURL)
		currentTarget = $(event.currentTarget)
		icon = currentTarget.find("i")
		icon.toggleClass("fa-expand").toggleClass("fa-compress")
		$("body").toggleClass("three-columns")
		$(window).trigger("resize")