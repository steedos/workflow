Meteor.startup ->
	new Tabular.Table
		name: "DistributeFlows",
		collection: db.flows,
		columns: [
			{data: "name", title: "name"},
			{
				data: "",
				title: "",
				orderable: false,
				width: '1px',
				render: (val, type, doc) ->
					return '<button type="button" class="btn btn-xs btn-default" id="distribute_edit_flow"><i class="fa fa-pencil"></i></button>'
			}
		]
		extraFields: ["current", "distribute_optional_users", "distribute_to_self"]
		lengthChange: false
		pageLength: 10
		info: false
		searching: true
		autoWidth: false