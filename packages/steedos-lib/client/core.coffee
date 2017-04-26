$.jstree.defaults.core.themes.variant = "large"

Meteor.startup ->
	if SC.setupBodyClassNames
		SC.setupBodyClassNames()