if Meteor.isServer
	Meteor.startup ()->
		db.flows.copy = (userId, spaceId, flowId, newFlowName, enabled)->
			flow = db.flows.findOne({_id: flowId, space: spaceId}, {fields: {_id: 1, name: 1, form: 1}})

			if !flow
				throw Meteor.Error("[flow.copy]未找到flow, space: #{spaceId}, flowId: #{flowId}");

			if newFlowName
				newName = newFlowName
			else
				newName = "复制:" + flow.name

			form = steedosExport.form(flow.form, flow._id, true)

			if _.isEmpty(form)
				throw Meteor.Error("[flow.copy]未找到form, formId: #{flow.form}");

			form.name = newName

			form.flows?.forEach (f)->
				f.name = newName

			steedosImport.workflow(userId, spaceId, form, enabled)

Meteor.methods
	flow_copy: (spaceId, flowId, newName)->
		if (!this.userId)
			return;

		if !Steedos.isSpaceAdmin(spaceId, this.userId)
			throw  Meteor.Error("No permission");

		db.flows.copy(this.userId, spaceId, flowId, newName, false)