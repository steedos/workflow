Template.forward_select_flow_modal.helpers({
    flow_list_data: function() {
        if (!Steedos.subsForwardRelated.ready()) {
            return;
        }

        return WorkflowManager.getFlowListData('forward');
    },

    empty: function(categorie) {
        if (!categorie.forms || categorie.forms.length < 1)
            return false;
        return true;
    },

    equals: function(a, b) {
        return a == b;
    },

    spaces: function() {
        return db.spaces.find();
    },

    spaceName: function() {
        if (Session.get('forward_space_id')) {
            space = db.spaces.findOne(Session.get("forward_space_id"))
            if (space)
                return space.name
        }

        return t("Steedos")
    }

})

Template.forward_select_flow_modal.onRendered(function() {
    if (!Session.get('forward_space_id') && Session.get('spaceId')) {
        Session.set('forward_space_id', Session.get('spaceId'));
    }
})


Template.forward_select_flow_modal.events({

    'click .dropdown-menu li': function(event, template) {
        var space_id = this._id;
        Session.set('forward_space_id', space_id);
    },

    'click .flow_list_box .weui_cell': function(event, template) {
        flow = event.currentTarget.dataset.flow;

        console.log("forwardIns flow is " + flow)

        if (!flow)
            return;

        Modal.hide(template);
        InstanceManager.forwardIns(Session.get('instanceId'), Session.get('forward_space_id'), flow);
    }

})