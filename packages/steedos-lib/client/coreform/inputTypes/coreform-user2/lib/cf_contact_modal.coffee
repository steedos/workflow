Template.cf_contact_modal.events
	'click #confirm': (event, template) ->
		console.log("..confirm");
		
		# targetId = template.data.targetId;

		target = $("#"+template.data.targetId)


		values = new Array();
		datasetValues=  new Array();
		$('[name=\'contacts_ids\']').each ->
		  if @checked
		    values.push(@dataset.name);
		    datasetValues.push(@value);

		    # selectize.createItem(@dataset.name + "<" + @dataset.email + ">")

		target.val(values.toString());  
		target.data("values", datasetValues.toString());
		Modal.hide("cf_contact_modal");

