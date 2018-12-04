Template.flow_list_box_org_modal.helpers
    contactsTreeData: ()->
        return { showCompanyOnly: true }
    contactsListData: ()->
        console.log("contactsListData...")
        # return {defaultValues:MailManager.getContacts(this.targetId)}; 
        return {}
    subsReady: ->
        return true
        # return Steedos.subsAddressBook.ready() and Steedos.subsSpace.ready();

Template.flow_list_box_org_modal.events
    'click #confirm': (event, template) ->
        Modal.hide(template);

Template.flow_list_box_org_modal.onRendered ->
