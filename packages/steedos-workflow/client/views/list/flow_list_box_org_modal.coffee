Template.flow_list_box_org_modal.helpers
    contactsTreeData: ()->
        return Template.instance().data
    subsReady: ->
        return Steedos.subsSpace.ready();
    flowListData: ()->
        return Template.instance().data
    title: ()->
        title = Template.instance().data?.title
        if title
            return title
        else
            return t "Fill in form"

Template.flow_list_box_org_modal.events

Template.flow_list_box_org_modal.onRendered ->
