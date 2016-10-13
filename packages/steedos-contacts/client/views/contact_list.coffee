Template.contacts_list.helpers 
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

Template.contacts_list.events
    'click #reverse': (event, template) ->
        $('input[name="contacts_ids"]', $(".contacts-list")).each ->
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

Template.contacts_list.onRendered ->
    TabularTables.contacts.customData = @data
    TabularTables.contactsBooks.customData = @data
    
    ContactsManager.setContactModalValue(@data.defaultValues);

    ContactsManager.handerContactModalValueLabel();
    $("#contact_list_load").hide();