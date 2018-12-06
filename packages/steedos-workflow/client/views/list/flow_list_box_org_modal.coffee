Template.flow_list_box_org_modal.helpers
    contactsTreeData: ()->
        return { showCompanyOnly: true }
    subsReady: ->
        return Steedos.subsSpace.ready();

Template.flow_list_box_org_modal.events
    'click #confirm': (event, template) ->
        Modal.hide(template);

Template.flow_list_box_org_modal.onRendered ->
