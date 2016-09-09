Template.cf_contact_modal.events
	'click #confirm': (event, template) ->
		console.log("..confirm");

		target = $("#"+template.data.targetId)
		
		values = CFDataManager.getCheckedValues();

		target.val(values.getProperty("name").toString());
		
		target[0].dataset.values = values.getProperty("id").toString();
		
		Modal.hide("cf_contact_modal");

