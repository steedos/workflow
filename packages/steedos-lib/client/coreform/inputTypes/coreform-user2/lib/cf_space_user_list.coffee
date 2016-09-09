Template.cf_space_user_list.helpers 
    selector: ->
        query = {space: Session.get("spaceId")};

        orgId = Session.get("selectOrgId");

        childrens = SteedosDataManager.organizationRemote.find({parents: orgId},{fields:{_id:1}});
        orgs = childrens.getProperty("_id");
        orgs.push(orgId);

        query.organization = {$in: orgs};
        return query;

    toString: ()->
        console.log(this.data);
        return JSON.stringify(this.data);



Template.cf_space_user_list.events
    'click #reverse': (event, template) ->
        $('input[name="contacts_ids"]', $(".cf_space_user_list_table")).each ->
            $(this).prop 'checked', !$(this).prop('checked')

    'change .list_checkbox': (event, template) ->

        values = CFDataManager.getCheckedValues();

        if values.length > 0
          html = ''
          values.forEach (v) ->
            html = html + '\u000d\n<li data-value=' + v.id + '>' + v.name + '</li>'
            #html = html + '\r\n<span><li data-value='+v.id+'>' + v.name + '</li><li class="remove"><i class="fa fa-times" aria-hidden="true"></i></li></span>'
            return
          $('#valueLabel', $(".cf_contact_modal")).html html
          Sortable.create $('#valueLabel')[0],
            group: 'words'
            animation: 150
            onRemove: (event) ->
              console.log 'onRemove...'
              return
            onEnd: (event) ->
              values = []
              $('#valueLabel li').each ->
                li = this
                values.push li.dataset.value
                return
              selectTag.values = values
              return
          $('#valueLabel_ui').show()
        else
          $('#valueLabel_ui').hide()

Template.cf_space_user_list.onRendered ->
    TabularTables.cf_tabular_space_user_checkbox.customData = @data
    # $("#contact_list_load").hide();