Template.cf_contact_modal.helpers
	footer_display: (multiple)->
		if !multiple
			return "display:none";
		return "";

	modalStyle: (showOrg) ->
		if showOrg && !Steedos.isMobile()
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
		$(".cf-users-organization-modal-body").css(cssHeightKey, ($(window).height() - 180 - 25) + "px");

	'hide.bs.modal #cf_contact_modal': (event, template) ->
		Modal.allowMultiple = false;
		return true;

Template.cf_contact_modal.onRendered ->
	CFDataManager.setContactModalValue(CFDataManager.getFormulaSpaceUsers(@data.defaultValues));
	CFDataManager.handerContactModalValueLabel();
	cssHeightKey = "max-height"
	if Steedos.isMobile()
		cssHeightKey = "height"
	$(".cf-organization-list").css(cssHeightKey, ($(window).height() - 180 - 25) + "px");
	$(".cf-spaceusers-list").css(cssHeightKey, ($(window).height() - 180 - 25) + "px");

