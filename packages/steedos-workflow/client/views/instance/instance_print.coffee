Template.instancePrint.helpers
    hasInstance: ()->
        Session.get("instanceId");
        instance = WorkflowManager.getInstance();
        if instance
            return true
        return false

    instance: ()->
        return WorkflowManager.getInstance();

# 只有在流程属性上设置tableStype 为true 并且不是手机版才返回true.
    isTableView: (flowId)->
        flow = WorkflowManager.getFlow(flowId);

        if Steedos.isMobile()
            return false

        if flow?.instance_style == 'table'
            return true
        return false

    unequals: (a, b) ->
        return !(a == b)

Template.instancePrint.step = 1;

Template.instancePrint.plusFontSize = (node)->
    if node?.children()
        node.children().each (i, n) ->
            cn = $(n)

            if cn?.children().length > 0 && cn?.children("br").length < cn?.children().length
                Template.instancePrint.plusFontSize(cn)
            else
#                if cn?.prop("style")?.fontSize
#                    console.log(cn.prop("style").fontSize);

                if cn?.css("font-size")

                    thisFZ = cn.css("font-size")

                    unit = thisFZ.slice(-2)

                    cn.css("font-size", parseFloat(thisFZ, 10) + Template.instancePrint.step + unit);

Template.instancePrint.minusFontSize = (node)->
    if node?.children()
        node.children().each (i, n) ->
            cn = $(n)

            if cn?.children().length > 0 && cn?.children("br").length < cn?.children().length
                Template.instancePrint.minusFontSize(cn)
            else
#                if cn?.prop("style")?.fontSize
#                    console.log(cn.prop("style").fontSize);

                if cn?.css("font-size")
                    cn.css("font-size", parseFloat(cn.css("font-size"), 10) - Template.instancePrint.step + "px");

Template.instancePrint.events
    "change #print_traces_checkbox": (event, template) ->
        if event.target.checked
            $(".instance-traces").show()
        else
            $(".instance-traces").hide()

    "change #print_attachments_checkbox": (event, template) ->
        if event.target.checked
            $(".instance_attachments").show()
        else
            $(".instance_attachments").hide()

    "click #instance_to_print": (event, template) ->
        window.print()

    "click #font-plus": (event, template) ->
        Template.instancePrint.plusFontSize $(".instance")

    "click #font-minus": (event, template) ->
        Template.instancePrint.minusFontSize $(".instance")