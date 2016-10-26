    TabularTables.steedosContactsOrganizations = new Tabular.Table({
      name: "steedosContactsOrganizations",
      collection: db.space_users,
      columns: [
        {
          data: "_id", 
          title: '<input type="checkbox" name="reverse" id="reverse">',
          orderable: false,
          width:'30px',
          render:  (val, type, doc) ->

            input = '<input type="checkbox" class="contacts-list-checkbox" name="contacts_ids" id="contacts_ids" value="' + doc._id + '" data-name="' + doc.name + '" data-email="' + doc.email + '"'

            if TabularTables.steedosContactsOrganizations.customData?.defaultValues?.getProperty("email").includes(doc.email)
              input += " checked "

            input += ">"
            return input
        },
        {
          data: "name", 
          render:  (val, type, doc) ->
            return "<div class='contacts-name'>" + doc.name + "</div>"
        },
        {
          data: "email",
          render:  (val, type, doc) ->
            return "<div class='contacts-email'>" + doc.email + "</div>"
        },
        {
          data: "",
          title: "编辑",
          orderable: false,
          width:'40px',
          render: (val, type, doc) ->
            return '<button type="button" class="btn btn-xs btn-primary" id="steedos_contacts_org_user_list_edit_btn" data-id="' + doc._id + '"><i class="fa fa-pencil"></i></button>'
        },
        {
          data: "",
          title: "删除",
          orderable: false,
          width:'40px',
          render: (val, type, doc) ->
            return '<button type="button" class="btn btn-xs btn-primary" id="steedos_contacts_org_user_list_remove_btn" data-id="' + doc._id + '"><i class="fa fa-times"></i></button>'
        }

      ],

      #select:
      #  style: 'single'
      dom: "tp",
      order:[[1,"desc"]]
      extraFields: ["_id", "name", "email"],
      lengthChange: false,
      pageLength: 15,
      info: false,
      searching: true,
      responsive: 
        details: false
      autoWidth: false,

      #scrollY:        '400px',
      #scrollCollapse: true,
      pagingType: "numbers"

    });