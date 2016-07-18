Template.workflow_home.helpers


Template.workflow_home.events
    'click [name="create_ins_btn"]': (event) ->
        Session.set('flow_list_modal_type', 'create')
        #Modal.show('flow_list_modal')
        Modal.show("flow_list_box_modal")