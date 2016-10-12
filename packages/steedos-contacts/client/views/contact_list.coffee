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
            $(this).prop 'checked', event.target.checked

Template.contacts_list.onRendered ->
    $("#contact_list_load").hide();