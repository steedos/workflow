InstanceNumberRules = {};

InstanceNumberRules.instanceNumberBuilder = (element, name) ->
	Meteor.call "instanceNumberBuilder", name, (error, result) ->
		if error
			toastr.error(error.reason, "编号生成失败")
		else
			element?.val(result).trigger("change")