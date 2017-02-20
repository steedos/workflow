Template.cf_space_user_list.helpers
	selector: (userOptions)->
		query = {space: Session.get("spaceId"), user_accepted: true};
		if userOptions != undefined && userOptions != null
			query.user = {$in: userOptions.split(",")};
		else
			if !Session.get("cf_contact_list_search")
				orgAndChild = Session.get("cf_orgAndChild");
				query.organizations = {$in: orgAndChild};
		return query;


Template.cf_space_user_list.events
	'click #cf_reverse': (event, template) ->
		$('input[name="cf_contacts_ids"]', $(".cf_space_user_list_table")).each ->
			$(this).prop('checked', event.target.checked).trigger('change')
	'click .for-input': (event, template) ->
		values = CFDataManager.getContactModalValue();
		userId = event.currentTarget.dataset.user
		if values.getProperty("id").indexOf(userId) < 0
			$("#"+userId).prop('checked', true).trigger('change')
		else
			$("#"+userId).prop('checked', false).trigger('change')

	'change .list_checkbox': (event, template) ->
		console.log("change .list_checkbox");

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

		CFDataManager.setContactModalValue(values);

		CFDataManager.handerContactModalValueLabel();

	'input #cf-contact-list-search-key': (event, template) ->
		if $("#cf-contact-list-search-key").val() && $("#cf-contact-list-search-key").val().length > 1
			Session.set("cf_contact_list_search", true)
		else if Session.get("cf_contact_list_search")
			Session.set("cf_contact_list_search", false)
		else
			return ;
		dataTable = $(".cf_space_user_list_table").DataTable();
		dataTable.search(
			$("#cf-contact-list-search-key").val(),
		).draw();

Template.cf_space_user_list.onRendered ->
	TabularTables.cf_tabular_space_user.customData = @data

	if !@data.multiple
		$("#cf_reverse").hide();

# CFDataManager.setContactModalValue(@data.defaultValues);
# $("#contact_list_load").hide();