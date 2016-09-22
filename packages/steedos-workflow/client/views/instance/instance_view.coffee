Template.instance_view.helpers
    instance: ->
        Session.get("change_date")
        if (Session.get("instanceId"))
            steedos_instance = WorkflowManager.getInstance();
            return steedos_instance;

    space_users: ->
        return db.space_users.find();

    unequals: (a,b) ->
        return !(a == b)

    # 只有在表单属性上设置tableStype 为true 并且不是手机版才返回true.
    isTableView: (formId)->
        form = WorkflowManager.getForm(formId);

        if Steedos.isMobile()
            return false

        if form?.is_table_style
            return true
        # return true
        return false;

Template.instance_view.onRendered ->
    $(".workflow-main").addClass("instance-show")
    
Template.instance_view.events
    'change .instance .form-control,.instance .suggestion-control,.instance .checkbox input,.instance .af-radio-group input,.instance .af-checkbox-group input': (event, template) ->
        Session.set("instance_change", true);
    'change .ins-file-input': (event, template)->

            InstanceManager.uploadAttach(event.target.files, false)

            $(".ins-file-input").val('')

