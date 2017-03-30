if Meteor.isClient

	Template.atTitle.onRendered ->
		$(".at-form .at-title h3").text("河北港口集团协同办公系统");