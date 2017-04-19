Template.instance_approves_list.helpers
	selector: ()->
		unless Meteor.user()
			return {make_a_bad_selector: 1}
		query = {space: Session.get("spaceId")}
		

		instance_approves_more_search_selector = Session.get('instance_approves_more_search_selector')
		if (instance_approves_more_search_selector)
			_.keys(instance_approves_more_search_selector).forEach (k)->
				query[k] = instance_approves_more_search_selector[k]

		return query

	is_display_search_tip: ->
		if Session.get('instance_approves_more_search_selector') or Session.get('instance_search_val') or Session.get("flowId")
			return ""
		return "display: none;"




Template.instance_approves_list.events
