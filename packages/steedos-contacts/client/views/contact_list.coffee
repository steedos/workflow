Template.contacts_list.helpers 
    contacts: ()->
        return ContactsManager.getContacts(Session.get("contacts_orgId"));
    selector: ->
        query = {space: Session.get("spaceId")};

        orgId = Session.get("contacts_orgId");

        childrens = db.organizations.find({parents: orgId},{fields:{_id:1}}).fetch();

        orgs = childrens.getProperty("_id");
        
        orgs.push(orgId);

        query.organization = {$in: orgs};
        
        return query;

Template.contacts_list.events
    'click #reverse': (event, template) ->
        console.log("------------反选-----------")
        $('input[name="contacts_ids"]', $(".contacts_list_table")).each ->
            $(this).prop 'checked', !$(this).prop('checked')

Template.contacts_list.onRendered ->
    $("#contact_list_load").hide();