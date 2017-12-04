db.flows = new Meteor.Collection('flows')

if Meteor.isServer
	db.flows.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();
		if doc.current
			doc.current.created_by = userId;
			doc.current.created = new Date();
			doc.current.modified_by = userId;
			doc.current.modified = new Date();

	db.flows.copy = (userId, spaceId, flowId, newFlowName, enabled)->

		flow = db.flows.findOne({_id: flowId, space: spaceId}, {fields: {_id: 1, name: 1, form: 1}})

		if !flow
			throw Meteor.Error("[flow.copy]未找到flow, space: #{spaceId}, flowId: #{flowId}");

		if newFlowName
			newName = newFlowName
		else
			newName = "复制:" + flow.name

		form = steedosExport.form(flow.form, flow._id, true)

		if _.isEmpty(form)
			throw Meteor.Error("[flow.copy]未找到form, formId: #{flow.form}");

		form.name = newName

		form.flows?.forEach (f)->
			f.name = newName

		steedosImport.workflow(userId, spaceId, form, enabled)


db.flows._simpleSchema = new SimpleSchema
	space: 
		type: String,
		autoform: 
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	name: 
		type: String

	print_template:
		type: String,
		optional: true
		autoform:
			rows: 10,

	instance_template:
		type: String,
		optional: true
		autoform:
			rows: 10,

	name_formula:
		type: String
		optional: true
		autoform:
			omit: true

	code_formula:
		type: String
		optional: true
		autoform:
			omit: true

	description:
		type: String
		optional: true
		autoform:
			rows: 5

	is_valid:
		type: Boolean
		optional: true
		autoform:
			omit: true

	form:
		type: String
		optional: true
		autoform:
			omit: true

	flowtype:
		type: String
		optional: true
		autoform:
			omit: true

	state:
		type: String
		optional: true
		defaultValue: "disabled"
		autoform:
			omit: true

	is_deleted:
		type: Boolean
		optional: true
		autoform:
			omit: true

	created:
		type: Date
		optional: true
		autoform:
			omit: true

	created_by:
		type: String
		optional: true
		autoform:
			omit: true

	help_text:
		type: String
		optional: true
		autoform:
			omit: true

	current_no:
		type: Number
		optional: true
		autoform:
			omit: true

	current:
		type: Object
		optional: true
		blackbox: true
		autoform:
			omit: true

	historys:
		type: [Object]
		optional: true
		blackbox: true
		autoform:
			omit: true

	perms:
		type: Object
		optional: true
		blackbox: true
		autoform:
			omit: true

	error_message:
		type: Object
		optional: true
		blackbox: true
		autoform:
			omit: true

	app:
		type: String
		optional: true
		autoform:
			omit: true

	events:
		type: String
		optional: true
		autoform: 
			rows: 20

	field_map:
		type: String
		optional: true
		autoform:
			rows: 20

	distribute_optional_users:
		type: [Object]
		optional: true
		blackbox: true
		autoform:
			omit: true

	'current.steps.$.distribute_optional_flows':
		type: [String]
		optional: true
		autoform:
			omit: true

	distribute_to_self:
		type: Boolean
		optional: true
		autoform:
			omit: true

if Meteor.isClient
	db.flows._simpleSchema.i18n("flows")

db.flows.attachSchema(db.flows._simpleSchema)

if Meteor.isServer

	db.flows.allow
		insert: (userId, event) ->
			return false

		update: (userId, event) ->
			if (!Steedos.isSpaceAdmin(event.space, userId))
				return false
			else
				return true

		remove: (userId, event) ->
			return false
	
	db.flows.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

	db.flows.before.update (userId, doc, fieldNames, modifier, options) ->
	
		modifier.$set = modifier.$set || {};

		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();
		if (!Steedos.isLegalVersion(doc.space,"workflow.professional"))
			throw new Meteor.Error(400, "space_paid_info_title");
		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

	db.flows.before.remove (userId, doc) ->

		if (!Steedos.isSpaceAdmin(doc.space, userId))
			throw new Meteor.Error(400, "error_space_admins_only");

new Tabular.Table
	name: "Flows",
	collection: db.flows,
	columns: [
		{data: "name", title: "name"},
		{
			data: "created",
			title: "created",
			render: (val, type, doc)->
				return moment(doc.created).format('YYYY-MM-DD HH:mm')
		},
		{data: "state", title: "state"},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->

				return """
						<div class="flow-edit">
							<div class="btn-group">
							  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
								<span class="ion ion-android-more-vertical"></span>
							  </button>
							  <ul class="dropdown-menu dropdown-menu-right" role="menu">
								<li><a href="#" id="editFlow" data-id="#{doc._id}">#{t("Edit")}</a></li>
								<li class="divider"></li>
								<li><a href="#" id="editFlow_template" data-id="#{doc._id}">设置模版</a></li>
								<li><a href="#" id="editFlow_events" data-id="#{doc._id}">设置脚本</a></li>
								<li><a href="#" id="editFlow_fieldsMap" data-id="#{doc._id}">设置字段关系</a></li>
								<li class="divider"></li>
								<li><a target="_blank" id="exportFlow" href="/api/workflow/export/form?form=#{doc.form}">#{t("flows_btn_export_title")}</a></li>
								<li><a href="#">#{t("复制流程")}</a></li>
							  </ul>
							</div>
						</div>
					"""
		}
	]
	extraFields: ["form","print_template","instance_template","events","field_map","space", "description"]
	lengthChange: false
	pageLength: 10
	info: false
	searching: true
	autoWidth: false

new Tabular.Table
	name: "ImportOrExportFlows",
	collection: db.flows,
	columns: [
		{data: "name", title: "name"},
#		{data: "state", title: "state"},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				return '<a target="_blank" class="btn btn-xs btn-default" id="exportFlow" href="/api/workflow/export/form?form=' + doc.form + '">' + t("flows_btn_export_title") + '</a>'
		}
	]
	extraFields: ["form","print_template","instance_template","events","field_map","space"]
	lengthChange: false
	pageLength: 10
	info: false
	searching: true
	autoWidth: false

if Meteor.isServer
	db.flows._ensureIndex({
		"is_deleted": 1
	},{background: true})

	db.flows._ensureIndex({
		"space": 1
	},{background: true})

	db.flows._ensureIndex({
		"space": 1,
		"is_deleted": 1
	},{background: true})

	db.flows._ensureIndex({
		"role": 1,
		"is_deleted": 1
	},{background: true})

	db.flows._ensureIndex({
		"space": 1,
		"app": 1,
		"created": 1
	},{background: true})

	db.flows._ensureIndex({
		"space": 1,
		"app": 1,
		"created": 1,
		"current.modified": 1
	},{background: true})

	db.flows._ensureIndex({
		"name": 1,
		"space": 1
	},{background: true})

	db.flows._ensureIndex({
		"form": 1,
		"is_deleted": 1
	},{background: true})

	db.flows._ensureIndex({
		"current.steps.approver_roles": 1,
		"space": 1,
		"is_deleted": 1
	},{background: true})

	db.flows._ensureIndex({
		"_id": 1,
		"space": 1,
		"is_deleted": 1
	},{background: true})

	db.flows._ensureIndex({
		"space": 1,
		"form": 1
	},{background: true})

	db.flows._ensureIndex({
		"form": 1
	},{background: true})

	db.flows._ensureIndex({
		"space": 1,
		"form": 1,
		"state:": 1
	},{background: true})