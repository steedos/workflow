Template.instance_traces_table.helpers(TracesTemplate.helpers);

Template.instance_traces_table.events(TracesTemplate.events)

Template.instance_traces_table.onRendered(function () {
    if (!Session.get("instancePrint")) {
        $("#tracesCollapse").parent().hide()
    }
})
