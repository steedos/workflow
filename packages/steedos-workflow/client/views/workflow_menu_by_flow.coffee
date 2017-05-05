Template.workflowMenuByFlow.helpers
    data: ()->
        data = []

        inboxInstances = InstanceManager.getUserInboxInstances()

        inboxInstancesGroupBySpace = _.groupBy(inboxInstances, "space")
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

    boxActive: (box)->
        if box == Session.get("box")
            return "weui-bar__item_on"

    isInbox: ()->
        return Session.get("box") == "inbox"

    isSelected: (flowId)->
        if Session.get("flowId") == flowId
            return "selected"

    maxHeight: ->
        return Template.instance().maxHeight.get() - 51 + 'px'

    showNavbar: ->
#        return Steedos.isMobile()
        return false;


Template.workflowMenuByFlow.events
    'click .weui-navbar__item': (event, template)->

        box = event.currentTarget.dataset?.box

        FlowRouter.go("/workflow/space/" + Session.get("spaceId") + "/" + box + "/");

Template.workflowMenuByFlow.onCreated ->
    self = this;

    self.maxHeight = new ReactiveVar(
        $(window).height());

    $(window).resize ->
        self.maxHeight?.set($(".instance-list",$(".steedos")).height());


Template.workflowMenuByFlow.onRendered ->
    self = this;

    self.maxHeight?.set($(".instance-list",$(".steedos")).height());