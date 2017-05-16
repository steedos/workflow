Steedos.subs["InstanceTabular"] = new SubsManager()

TabularTables.instances = new Tabular.Table({
	name: "instances",
	collection: db.instances,
	pub: "instance_tabular",
	sub: Steedos.subs["InstanceTabular"],
	onUnload: ()->
		console.log "on unload"
	drawCallback: (settings)->
		if !Steedos.isMobile() && !Steedos.isPad()
			$(".instance-list").scrollTop(0).ready ->
				$(".instance-list").perfectScrollbar("update")
	createdRow: (row, data, dataIndex) ->
		if Meteor.isClient
			if data._id == FlowRouter.current().params.instanceId
				row.setAttribute("class", "selected")
	columns: [
		{
			data: "_id",
			render: (val, type, doc) ->
				modifiedString = moment(doc.modified).format('YYYY-MM-DD');
				modifiedFromNow = Steedos.momentReactiveFromNow(doc.modified);
				flow_name = WorkflowManager.getFlow(doc.flow)?.name
				cc_view = "";
				step_current_name_view = "";
				# 当前用户在cc user中，但是不在inbox users时才显示'传阅'文字
				if doc.cc_users?.includes(Meteor.userId()) && !doc.inbox_users?.includes(Meteor.userId()) && Session.get("box") == 'inbox'
					cc_view = "<label class='cc-label'>(" + TAPi18n.__("instance_cc_title") + ")</label> "
					step_current_name_view = "<div class='flow-name'>#{flow_name}<span>(#{doc.step_current_name})</span></div>"
				else
					if Session.get("box") != 'draft' && doc.step_current_name
#step_current_name_view = "<label class='c'>(" + doc.step_current_name + ")</label> "
						step_current_name_view = "<div class='flow-name'>#{flow_name}<span>(#{doc.step_current_name})</span></div>"
					else
						step_current_name_view = "<div class='flow-name'>#{flow_name}</div>"

				unread = ''

				if Session.get("box") == 'inbox' && doc.is_read == false
					unread = '<i class="ion ion-record unread"></i>'

				return """
							<div class='instance-read-bar'>#{unread}</div>
							<div class='instance-name'>#{doc.name}#{cc_view}
								<span>#{doc.applicant_name}</span>
							</div>
							<div class='instance-detail'>#{step_current_name_view}
								<span class='instance-modified' title='#{modifiedString}'>#{modifiedFromNow}</span>
							</div>
						"""
		},
		{
			data: "applicant_organization_name",
			visible: false,
		},
		{
			data: "name",
			render: (val, type, doc) ->
				cc_view = "";
				step_current_name_view = "";
				# 当前用户在cc user中，但是不在inbox users时才显示'传阅'文字
				if doc.cc_users?.includes(Meteor.userId()) && !doc.inbox_users?.includes(Meteor.userId()) && Session.get("box") == 'inbox'
					cc_view = "<label class='cc-label'>(" + TAPi18n.__("instance_cc_title") + ")</label> "

				unread = ''

				if Session.get("box") == 'inbox' && doc.is_read == false
					unread = '<i class="ion ion-record unread"></i>'

				return """
						<div class='instance-read-bar'>#{unread}</div>
						<div class='instance-name'>#{doc.name}#{cc_view}</div>
					"""
			visible: false,
			orderable: false
		},
		{
			data: "applicant_name",
			visible: false,
			orderable: false
		},{
			data: "submit_date",
			render: (val, type, doc) ->
				if doc.submit_date
					return moment(doc.submit_date).format('YYYY-MM-DD hh:mm');
			,
			visible: false
		},
		{
			data: "flow"
			render: (val, type, doc) ->
				flow_name = WorkflowManager.getFlow(doc.flow)?.name
				return flow_name
			,
			visible: false
		},{
			data: "step_current_name",
			visible: false
		},
		{
			data: "modified",
			render: (val, type, doc) ->
				return Steedos.momentReactiveFromNow(doc.modified);
			,
			visible: false
		}
	],
	dom: "tp",
	order: [[7, "desc"]]
	extraFields: ["form", "flow", "inbox_users", "outbox_users", "state", "space", "applicant", "form_version", "flow_version", "cc_users", "is_read", "step_current_name"],
	lengthChange: false,
	pageLength: 10,
	info: false,
	searching: true,
	responsive:
		details: false
	autoWidth: false,
	changeSelector: (selector, userId) ->
		unless userId
			return {make_a_bad_selector: 1}
		space = selector.space
		unless space
			if selector?.$and?.length > 0
				space = selector.$and.getProperty('space')[0]
		unless space
			return {make_a_bad_selector: 1}
		space_user = db.space_users.findOne({user: userId, space: space}, {fields: {_id: 1}})
		unless space_user
			return {make_a_bad_selector: 1}
		return selector
	pagingType: "numbers"

});

#TabularTables.instancesListTable = new Tabular.Table instancesListTableTabular()