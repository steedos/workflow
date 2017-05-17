Template.distribute_edit_flow_modal.helpers
	user_context: ()->



		# data = {
		# 	value: 
		# 	dataset: {
		# 		showOrg: false,
		# 		multiple: true,
		# 		userOptions: users_id,
		# 		values: users_id.toString()
		# 	},
		# 	name: 'instance_remind_select_users',
		# 	atts: {
		# 		name: 'instance_remind_select_users',
		# 		id: 'instance_remind_select_users',
		# 		class: 'selectUser form-control'
		# 	}
		# }

		# return data

	allow_distribute_steps: ()->
		if this.flow
			return _.where this.flow.current.steps, {allowDistribute: true}

		return new Array




Template.distribute_edit_flow_modal.events