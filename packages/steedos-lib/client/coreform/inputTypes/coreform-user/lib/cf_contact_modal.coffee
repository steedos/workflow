Template.cf_contact_modal.helpers
	footer_display: (multiple)->
		if !multiple
			return "display:none";
		return "";

	modalStyle: (showOrg) ->
		if !Steedos.isMobile()
			return "modal-lg";
		return "";

	isMobile: ()->
		return Steedos.isMobile();

	orgName: ()->
		orgId = Session.get("cf_selectOrgId");
		if orgId == '#'
			org = SteedosDataManager.organizationRemote.findOne({is_company: true}, {fields: {name: 1}});
		else
			org = SteedosDataManager.organizationRemote.findOne({_id: orgId}, {fields: {name: 1}});

		return org?.name;

	data: ()->
		Template.instance().data

	selectedUsrsSchema: ()->
		return new SimpleSchema({
			selected_users: {
				type: [String],
				optional: true,
				autoform: {
					type: "universe-select",
					afFieldInput: {
						multiple: true,
						optionsMethod: "getCFOptionSpaceUsers"
					}
				}
			}
		})

	selectedUsers: ()->
		return {selected_users: Template.instance().selected.get()}

	optionsMethodParams: (userOptions)->
		spaceId = Template.instance().data.spaceId
		is_within_user_organizations = Template.instance().data.is_within_user_organizations
		query = {space: spaceId, user_accepted: true};
		if userOptions != undefined && userOptions != null
			query.user = {$in: userOptions.split(",")};
		else
			if is_within_user_organizations
				orgs = db.organizations.find().fetch().getProperty("_id")
				query.organizations = {$in: orgs};

		return JSON.stringify({spaceId: spaceId, query: query, selected: Template.instance().selected.get()})

Template.cf_contact_modal.events
	'click #confirm': (event, template) ->
		target = $("#" + template.data.targetId)
		values = CFDataManager.getContactModalValue();

		target[0].dataset.values = values.getProperty("id").toString();

		target.val(values.getProperty("name").toString()).trigger('change');

		Modal.hide("cf_contact_modal");

		Modal.allowMultiple = false;

	'click #remove': (event, template) ->
		target = $("#" + template.data.targetId)
		target[0].dataset.values = "";
		target.val("").trigger('change');
		Modal.hide("cf_contact_modal");
		Modal.allowMultiple = false;

	'click .organization-active': (event, template) ->
		# Modal.show("cf_users_organization_modal");
		$('#cf_users_organization_modal_div').show()
		cssHeightKey = "max-height"
		if Steedos.isMobile()
			cssHeightKey = "height"
		$(".cf-users-organization-modal-body").css(cssHeightKey, Steedos.getModalMaxHeight(20));

	'hide.bs.modal #cf_contact_modal': (event, template) ->
		Modal.allowMultiple = false;
		return true;

	'change .list_checkbox': (event, template) ->

		target = event.target;

		if !template.data.multiple
			CFDataManager.setContactModalValue([{id: target.value, name: target.dataset.name}]);
			$("#confirm", $("#cf_contact_modal")).click();
			return;

		values = CFDataManager.getContactModalValue();

		if target.checked == true
			if values.getProperty("id").indexOf(target.value) < 0
				values.push({id: target.value, name: target.dataset.name});
		else
			values.remove(values.getProperty("id").indexOf(target.value))

		template.selected.set(values.getProperty("id"))

		CFDataManager.setContactModalValue(values);

		CFDataManager.handerContactModalValueLabel();

Template.cf_contact_modal.onCreated ->
	self = this;
	self.selected = new ReactiveVar([]);

Template.cf_contact_modal.onRendered ->

	self = this;

	self.selected.set self.data.defaultValues || []

	CFDataManager.setContactModalValue(CFDataManager.getFormulaSpaceUsers(@data.defaultValues));
	CFDataManager.handerContactModalValueLabel();
	cssHeightKey = "max-height"
	if Steedos.isMobile()
		cssHeightKey = "height"
	$(".cf-organization-list").css(cssHeightKey, Steedos.getModalMaxHeight(20));
	$(".cf-spaceusers-list").css(cssHeightKey, Steedos.getModalMaxHeight(20));

