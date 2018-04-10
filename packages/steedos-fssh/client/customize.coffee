if Meteor.isClient
	Meteor.startup ->
		Theme.icon = "/packages/steedos_fssh/assets/images/fssh-icon.png"
		Theme.icon_en = Theme.icon
		Theme.is_customized = true
		