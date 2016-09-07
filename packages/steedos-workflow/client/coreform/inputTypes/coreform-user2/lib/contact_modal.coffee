Template.select_modal.events
	'click #confirm': (event, template) ->
		console.log("..confirm");
		
		# targetId = template.data.targetId;

		selectize = template.data.target[0].selectize

		$('[name=\'contacts_ids\']').each ->
		  if @checked
		    console.log @dataset.name
		    selectize.createItem(@dataset.name + "<" + @dataset.email + ">")

		Modal.hide("contacts_modal");

