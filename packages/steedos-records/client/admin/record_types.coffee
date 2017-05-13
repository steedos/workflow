Template.admin_record_types.events
	'click tbody > tr':  (event) ->
		dataTable = $(event.target).closest('table').DataTable();
		rowData = dataTable.row(event.currentTarget).data();
		if (rowData)
			Session.set 'cmDoc', rowData 
			$('.btn.record-types-edit').click();