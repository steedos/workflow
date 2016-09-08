Template.cf_space_user_list.helpers 
    selector: ->
        query = {space: Session.get("spaceId")};

        orgId = Session.get("selectOrgId");

        childrens = SteedosDataManager.organizationRemote.find({parents: orgId},{fields:{_id:1}});

        orgs = childrens.getProperty("_id");
        
        orgs.push(orgId);

        query.organization = {$in: orgs};
        console.log("query is ");
        console.log(query);
        return query;

    toString: ()->
        console.log(this.data);
        return JSON.stringify(this.data);


Template.cf_space_user_list.events
    'click #reverse': (event, template) ->
        console.log("------------反选-----------")
        $('input[name="contacts_ids"]', $(".contacts_list_table")).each ->
            $(this).prop 'checked', !$(this).prop('checked')

Template.cf_space_user_list.onRendered ->
    debugger;

    console.log(this.data);

    # $("#contact_list_load").hide();