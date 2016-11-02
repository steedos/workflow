Template.steedos_contacts_org_user_list.helpers 
    showBooksList: ->
        if Session.get("contact_showBooks")
            return true
        return false;
    selector: ->
        query = {space: Session.get("spaceId"), user_accepted: true};

        orgId = Session.get("contacts_orgId");

        childrens = ContactsManager.getOrgAndChild(orgId);

        query.organizations = {$in: childrens};
        
        return query;

    books_selector: ->
        query = {owner: Meteor.userId()};
        if Session.get("contacts_groupId") != "parent"
            query.group = Session.get("contacts_groupId");
        return query;

    is_admin: ()->
        return Steedos.isSpaceAdmin()

    isMobile: ()->
        return Steedos.isMobile();

    getOrgName: ()->
        return SteedosDataManager.organizationRemote.findOne({_id:Session.get("contacts_orgId")},{fields:{name: 1}})?.name;

Template.steedos_contacts_org_user_list.events
    'click #reverse': (event, template) ->
        $('input[name="contacts_ids"]', $("#contacts_list")).each ->
            $(this).prop('checked', event.target.checked).trigger('change')

    'change .contacts-list-checkbox': (event, template) ->
        console.log("change .contacts-list-checkbox");

        target = event.target;

        values = ContactsManager.getContactModalValue();

        if target.checked == true
            if values.getProperty("email").indexOf(target.dataset.email) < 0
                values.push({id: target.value, name: target.dataset.name, email: target.dataset.email});
        else
            values.remove(values.getProperty("email").indexOf(target.dataset.email))

        ContactsManager.setContactModalValue(values);

        ContactsManager.handerContactModalValueLabel();

    'click #contact-list-search-btn': (event, template) ->
        console.log("contact-list-search-btn click");
        dataTable = $(".datatable-steedos-contacts").DataTable();
        dataTable.search(
            $("#contact-list-search-key").val(),
        ).draw();

    'click #steedos_contacts_org_user_list_edit_btn': (event, template) ->
        AdminDashboard.modalEdit 'space_users', event.currentTarget.dataset.id

    'click #steedos_contacts_org_user_list_remove_btn': (event, template) ->
        AdminDashboard.modalDelete 'space_users', event.currentTarget.dataset.id

    'click #steedos_contacts_invite_users_btn': (event, template) ->
        Modal.show('steedos_contacts_invite_users_modal')

    'click #steedos_contacts_show_orgs': (event, template)->
        listWrapper = $(".contacts-list-wrapper")
        if listWrapper.is(":hidden")
            listWrapper.show();
        else
            listWrapper.hide();

Template.steedos_contacts_org_user_list.onRendered ->
    TabularTables.steedosContactsOrganizations.customData = @data
    TabularTables.steedosContactsBooks.customData = @data
    
    ContactsManager.setContactModalValue(@data.defaultValues);

    ContactsManager.handerContactModalValueLabel();
    $("#contact_list_load").hide();