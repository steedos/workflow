TabularTables.steedosContactsOrganizations = new Tabular.Table({
	name: "steedosContactsOrganizations",
	collection: db.space_users,
	columns: [
# {
#   data: "_id",
#   title: '<input type="checkbox" name="reverse" id="reverse">',
#   orderable: false,
#   width:'1px',
#   render:  (val, type, doc) ->

#     input = '<input type="checkbox" class="contacts-list-checkbox" name="contacts_ids" id="contacts_ids" value="' + doc._id + '" data-name="' + doc.name + '" data-email="' + doc.email + '"'

#     if TabularTables.steedosContactsOrganizations.customData?.defaultValues?.getProperty("email").includes(doc.email)
#       input += " checked "

#     input += ">"
#     return input
# },
		{
			data: "name",
			orderable: false,
			render: (val, type, doc) ->
				return "<div class='contacts-name'>" + doc.name + "</div>"
		},
		{
			data: "email",
			orderable: false,
			render: (val, type, doc) ->
				return "<div class='contacts-email'>" + (doc.email || "") + "</div>"
		},
		{
			data: "mobile",
			orderable: false,
			render: (val, type, doc) ->
				return "<div class='contacts-mobile'>" + (doc.mobile || "") + "</div>"
		},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				return '<button type="button" class="btn btn-xs btn-primary" id="steedos_contacts_org_user_list_edit_btn" data-id="' + doc._id + '"><i class="fa fa-pencil"></i></button>'
		},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				return '<button type="button" class="btn btn-xs btn-primary" id="steedos_contacts_org_user_list_remove_btn" data-id="' + doc._id + '"><i class="fa fa-times"></i></button>'
		}

	],

#select:
#  style: 'single'
	dom: "tp",
#  order:[[1,"desc"]]
	extraFields: ["_id", "name", "email", "sort_no"],
	lengthChange: false,
	pageLength: 15,
	info: false,
	searching: true,
	responsive:
		details: false
	autoWidth: false,

#scrollY:        '400px',
#scrollCollapse: true,
	pagingType: "numbers"

});

TabularTables.steedosContactsOrganizationsReadOnly = new Tabular.Table({
	name: "steedosContactsOrganizationsReadOnly",
	collection: db.space_users,
	columns: [
		{
			data: "name",
			render: (val, type, doc) ->
				return "<div class='contacts-name'>" + doc.name + "</div>"
		},
		{
			data: "email",
			render: (val, type, doc) ->
				return "<div class='contacts-email'>" + doc.email + "</div>"
		},
		{
			data: "mobile",
			render: (val, type, doc) ->
				return "<div class='contacts-mobile'>" + (doc.mobile || "") + "</div>"
		}

	],

	dom: "tp",
	order: [[1, "desc"]]
	extraFields: ["_id", "name", "email"],
	lengthChange: false,
	pageLength: 15,
	info: false,
	searching: true,
	responsive:
		details: false
	autoWidth: false,
	pagingType: "numbers"
});