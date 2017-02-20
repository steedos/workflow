
Template.flow_list_box_modal.onRendered ->
    $(".flow-list-box-modal-body").css("max-height", ($(window).height()-140) + "px");

Template.flow_list_box_modal.events
    'click #new_help': (event, template) ->
        Steedos.openWindow(t("new_help"));
