db.space_user_signs.adminConfig = 
	icon: "globe"
	color: "blue"
	tableColumns: [
		{name: "userName()"},
		{name: "signImage()"}
	]
	extraFields: ["space", "user", 'sign']
	routerAdmin: "/app/admin"

Meteor.startup ->
	@space_user_signs = db.space_user_signs
	AdminConfig?.collections_add
		space_user_signs: db.space_user_signs.adminConfig