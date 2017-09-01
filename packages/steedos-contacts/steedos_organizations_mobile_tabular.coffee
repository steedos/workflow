TabularTables.steedosContactsMobileOrganizations = new Tabular.Table({
	name: "steedosContactsMobileOrganizations",
	collection: db.organizations,
	createdRow:(row,data,index)->
		row.dataset.id = data._id
	columns: [
		{
			data: "name",
			orderable: false,
			render: (val, type, doc) ->
				colorClass = if !doc.user_accepted then 'text-muted' else ''
				return "<div class='contacts-name #{colorClass} nowrap'>" + doc.name + "</div>"
		},
		{
			data: "sort_no",
			title: "",
			orderable: true,
			visible: false
		},
		{
			data: "name",
			title: "",
			orderable: true,
			visible: false
		}

	],

	dom: "tp",
	order:[[1,"desc"],[2,"asc"]],
	extraFields: ["_id", "name", "email", "organizations", "sort_no", "user_accepted", "user", "organization"],
	lengthChange: false,
	pageLength: -1,
	info: false,
	searching: true,
	responsive:
		details: false
	autoWidth: false,
	changeSelector: (selector, userId) ->
		unless userId
			return {_id: -1}
		space = selector.space
		unless space
			if selector?.$and?.length > 0
				space = selector.$and.getProperty('space')[0]
		unless space
			return {_id: -1}
		space_user = db.space_users.findOne({user: userId,space:space}, {fields: {_id: 1}})
		unless space_user
			return {_id: -1}
		return selector
	pagingType: "numbers"

});