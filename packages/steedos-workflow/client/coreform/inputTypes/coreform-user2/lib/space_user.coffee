Template.select_space_user.helpers 
    selector: ->
        query = {space: Session.get("spaceId")};

        orgId = Session.get("selectOrgId");

        childrens = DataManager.organizationRemote.find({parents: orgId},{fields:{_id:1}});

        orgs = childrens.getProperty("_id");
        
        orgs.push(orgId);

        query.organization = {$in: orgs};
        
        return query;

Template.select_space_user.events
    'click #reverse': (event, template) ->
        console.log("------------反选-----------")
        $('input[name="contacts_ids"]', $(".contacts_list_table")).each ->
            $(this).prop 'checked', !$(this).prop('checked')

Template.select_space_user.onRendered ->
    # $("#contact_list_load").hide();