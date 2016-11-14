Template.workflowMenuByFlow.helpers
    data: ()->
        data = [];
        inboxInstancesGroupBySpace = _.groupBy(db.instances.find({inbox_users: Meteor.userId()}).fetch(), "space")
        spaceIds = _.keys(inboxInstancesGroupBySpace);
        spaceIds.forEach (spaceId)->
            space = db.spaces.findOne(spaceId, {fields:{name:1}});
            space.flows = [];
            inboxInstancesGroupByFlow = _.groupBy(inboxInstancesGroupBySpace[spaceId], "flow");
            flowIds = _.keys(inboxInstancesGroupByFlow);
            flowIds.forEach (flowId)->
                flow = db.flows.findOne(flowId, {fields:{name:1, space: 1}}) || {name: flowId};
                flow.inbox_count = inboxInstancesGroupByFlow[flowId]?.length;
                space.flows.push(flow);

            data.push(space);
        return data

    isSelected: (flowId)->
        if Session.get("flowId") == flowId
            return "selected"