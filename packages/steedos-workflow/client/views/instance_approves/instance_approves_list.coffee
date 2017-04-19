Template.instance_approves_list.helpers
	selector: ()->
		return {}

	is_display_search_tip: ->
		if Session.get('instance_more_search_selector') or Session.get('instance_search_val') or Session.get("flowId")
			return ""
		return "display: none;"




Template.instance_approves_list.events
