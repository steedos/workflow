TabularTables.instance_approves = new Tabular.Table({
	name: "instance_approves",
	collection: db.instance_approves,
	columns: [
		{
			data: "name"
		}
		
	],

	dom: "tp",

	extraFields: [],
	lengthChange: false,
	pageLength: 100,
	info: false,
	searching: true,
	responsive:
		details: false
	autoWidth: false,
	# changeSelector: (selector, userId) ->
	# 	unless userId
	# 		return {make_a_bad_selector: 1}
	# 	space = selector.space
	# 	unless space
	# 		if selector?.$and?.length > 0
	# 			space = selector.$and.getProperty('space')[0]
	# 	unless space
	# 		return {make_a_bad_selector: 1}
	# 	space_user = db.space_users.findOne({user: userId, space: space}, {fields: {_id: 1}})
	# 	unless space_user
	# 		return {make_a_bad_selector: 1}
	# 	return selector
	pagingType: "numbers"

});