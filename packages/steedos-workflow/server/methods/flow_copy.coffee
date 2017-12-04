Meteor.methods
	flow_copy: (spaceId, flowId, newName)->
		if (!this.userId)
			return;

		if !Steedos.isSpaceAdmin(spaceId, this.userId)
			throw  Meteor.Error("No permission");

		db.flows.copy(this.userId, spaceId, flowId, newName, false)