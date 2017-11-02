
Template.flow_list_box_modal.onRendered ->

Template.flow_list_box_modal.events
    'click #new_help': (event, template) ->
        Steedos.openWindow(t("new_help"));
