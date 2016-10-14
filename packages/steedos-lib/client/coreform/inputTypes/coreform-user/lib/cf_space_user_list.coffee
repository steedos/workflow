Template.cf_space_user_list.helpers 
    selector: (userOptions)->
        query = {space: Session.get("spaceId"), user_accepted: true};
        if userOptions != undefined && userOptions != null
            query.user = {$in: userOptions.split(",")};
        else
            orgAndChild = Session.get("cf_orgAndChild");
            query.organizations = {$in: orgAndChild};
        # console.log("query is " + JSON.stringify(query));
        return query;



Template.cf_space_user_list.events
    'click #reverse': (event, template) ->
        $('input[name="contacts_ids"]', $(".cf_space_user_list_table")).each ->
            $(this).prop('checked', event.target.checked).trigger('change')


    'change .list_checkbox': (event, template) ->
        console.log("change .list_checkbox");

        target = event.target;

        if !template.data.multiple
            CFDataManager.setContactModalValue([{id: target.value, name: target.dataset.name}]);
            $("#confirm", $("#cf_contact_modal")).click();
            return ;

        values = CFDataManager.getContactModalValue();

        if target.checked == true
            if values.getProperty("id").indexOf(target.value) < 0
                values.push({id: target.value, name: target.dataset.name});
        else
            values.remove(values.getProperty("id").indexOf(target.value))

        CFDataManager.setContactModalValue(values);

        CFDataManager.handerContactModalValueLabel();


Template.cf_space_user_list.onRendered ->
    TabularTables.cf_tabular_space_user.customData = @data
    
    if !@data.multiple
        $("#reverse").hide();

    # CFDataManager.setContactModalValue(@data.defaultValues);
    # $("#contact_list_load").hide();