# Steedos Portal App 

Steedos Portal App is an Notification Center for corperate apps, just like Mac. 

### Modal Design
portal_dashboards
	space: "",
	name: "Corp Dashboard",
	freeboard: "Freeboard Script",
	description: ""

apps
	id: "",
	space: "",
	auth_name: "",
	on_click: ""

apps_auths
	space: "",
	id: "",
	name: "",, unique
	title: ""
  
[{
  name: 'ptr',
  title: "PTR域"
},{
  name: 'cnpc',
  title: "CNPC域"
}]


apps_auth_users
	space: "",
	auth_name: "",
	user: "",
	user_name: "",
	login_name: "",
	login_password: ""



{{Portal.GetAuthByName('cnpc').login_name}}