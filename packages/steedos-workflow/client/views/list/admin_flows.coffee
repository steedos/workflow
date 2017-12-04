
_editFlow = (template, _id, fields)->

	template.edit_fields.set(fields)

	Session.set 'cmDoc', db.flows.findOne(_id)

	setTimeout ()->
		$('.btn.record-types-edit').click();
	, 1

Template.admin_flows.onCreated ()->
	this.edit_fields = new ReactiveVar()

Template.admin_flows.onRendered ()->
	if !Steedos.isPaidSpace()
		Steedos.spaceUpgradedModal()
		FlowRouter.go("/admin/home")

Template.admin_flows.helpers
	selector: ->
		return {space: Session.get("spaceId"), is_deleted: false};
	updateButtonContent: ->
		return t("Update");

	fields: ->
		return Template.instance()?.edit_fields.get()


Template.admin_flows.events
	'click #editFlow': (event, template) ->
		_id = event.currentTarget.dataset.id

		if _id
			_editFlow(template, _id, 'name, description')

	'click #editFlow_template': (event, template)->
		_id = event.currentTarget.dataset.id

		if _id
			_editFlow(template, _id, 'print_template, instance_template')

	'click #editFlow_events': (event, template)->
		_id = event.currentTarget.dataset.id

		if _id
			_editFlow(template, _id, 'events')

	'click #editFlow_fieldsMap': (event, template)->
		_id = event.currentTarget.dataset.id
		if _id
			_editFlow(template, _id, 'field_map')

	'click #importFlow': (event)->
		Modal.show("admin_import_flow_modal");