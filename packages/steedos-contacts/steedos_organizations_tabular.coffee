TabularTables.steedosContactsOrganizations = new Tabular.Table({
	name: "steedosContactsOrganizations",
	collection: db.space_users,
	createdRow:(row,data,index)->
		row.dataset.id = data._id
		if Steedos.isSpaceAdmin() || (Session.get('contacts_is_org_admin') && !Session.get("contact_list_search"))
			$(row).addClass("drag-source").attr "draggable",true
	columns: [
		{
			data: "name",
			orderable: false,
			render: (val, type, doc) ->
				colorClass = if !doc.user_accepted then 'text-muted' else ''
				return "<div class='contacts-name #{colorClass} nowrap'>" + doc.name + "</div>"
		},
		{
			data: "email",
			orderable: false,
			render: (val, type, doc) ->
				colorClass = if !doc.user_accepted then 'text-muted' else ''
				return "<div class='contacts-email #{colorClass} nowrap'>" + (doc.email || "") + "</div>"
		},
		{
			data: "mobile",
			orderable: false,
			render: (val, type, doc) ->
				colorClass = if !doc.user_accepted then 'text-muted' else ''
				return "<div class='contacts-mobile #{colorClass} nowrap'>" + (doc.mobile || "") + "</div>"
		},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				if Steedos.isSpaceAdmin() || (Session.get('contacts_is_org_admin') && !Session.get("contact_list_search"))
					return '<button type="button" class="btn btn-xs btn-primary" id="steedos_contacts_org_user_list_edit_btn" data-id="' + doc._id + '"><i class="fa fa-pencil"></i></button>'
		},
		{
			data: "",
			title: "",
			orderable: false,
			width: '1px',
			render: (val, type, doc) ->
				if Steedos.isSpaceAdmin() || (Session.get('contacts_is_org_admin') && !Session.get("contact_list_search"))
					return '<button type="button" class="btn btn-xs btn-primary" id="steedos_contacts_org_user_list_remove_btn" data-id="' + doc._id + '"><i class="fa fa-times"></i></button>'
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

#select:
#  style: 'single'
	dom: "tp",
	order:[[5,"desc"],[6,"asc"]],
	extraFields: ["_id", "name", "email", "organizations", "sort_no", "user_accepted"],
	lengthChange: false,
	pageLength: 15,
	info: false,
	searching: true,
	responsive:
		details: false
	autoWidth: false,
	changeSelector: (selector, userId) ->
		unless userId
			return {make_a_bad_selector: 1}
		space = selector.space
		unless space
			if selector?.$and?.length > 0
				space = selector.$and.getProperty('space')[0]
		unless space
			return {make_a_bad_selector: 1}
		space_user = db.space_users.findOne({user: userId,space:space}, {fields: {_id: 1}})
		unless space_user
			return {make_a_bad_selector: 1}
		return selector
	pagingType: "numbers"

});