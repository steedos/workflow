Meteor.methods
	check_main_attach: (ins_id)->
		check ins_id, String
		uuflowManager.checkMainAttach(ins_id)
		return 'success'

