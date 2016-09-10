Template.cf_space_user_list.helpers 
    selector: ->
        query = {space: Session.get("spaceId")};

        orgId = Session.get("selectOrgId");

        childrens = SteedosDataManager.organizationRemote.find({parents: orgId},{fields:{_id:1}});
        orgs = childrens.getProperty("_id");
        orgs.push(orgId);

        query.organization = {$in: orgs};
        return query;



Template.cf_space_user_list.events
    'click #reverse': (event, template) ->
        $('input[name="contacts_ids"]', $(".cf_space_user_list_table")).each ->
            $(this).prop('checked', !$(this).prop('checked')).trigger('change')



    'change .list_checkbox': (event, template) ->
        console.log("change .list_checkbox");

        values = CFDataManager.getContactModalValue();
        
        target = event.target;

        if target.checked == true
            values.push({id: target.value, name: target.dataset.name});
        else
            values.remove(values.getProperty("id").indexOf(target.value))

        CFDataManager.setContactModalValue(values);

        CFDataManager.handerValueLabel();


Template.cf_space_user_list.onRendered ->
    TabularTables.cf_tabular_space_user_checkbox.customData = @data
    CFDataManager.setContactModalValue(@data.defaultValues);
    # $("#contact_list_load").hide();