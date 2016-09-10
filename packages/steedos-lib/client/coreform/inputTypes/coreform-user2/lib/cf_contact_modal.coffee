Template.cf_contact_modal.helpers 
	footer_display: (multiple)->
		if !multiple
			return "display:none";
		return "";
Template.cf_contact_modal.events
	'click #confirm': (event, template) ->
		console.log("..confirm");

		target = $("#"+template.data.targetId)

		values = CFDataManager.getContactModalValue();

		target.val(values.getProperty("name").toString()).trigger('change');
		
		target[0].dataset.values = values.getProperty("id").toString();
		
		Modal.hide("cf_contact_modal");

Template.cf_contact_modal.onRendered ->
    CFDataManager.setContactModalValue(CFDataManager.getFormulaSpaceUsers(@data.defaultValues));
    CFDataManager.handerValueLabel();

