    TabularTables.cf_tabular_space_user_radio = new Tabular.Table({
      name: "cf_tabular_space_user_radio",
      collection: db.space_users,
      columns: [
        {
          data: "_id", 
          title: ' ',
          orderable: false,
          width:'10px',
          render:  (val, type, doc) ->
            return '<input type="radio" name="contacts_ids" id="contacts_ids" value="' + doc.user + '" data-name="' + doc.name + '" data-email="' + doc.email + '">'
        },
        {
          data: "name", 
          orderable: false,
          render:  (val, type, doc) ->
            return "<div class='user-name'><img src='" + "/avatar/"+doc.user+"?w=30&h=30&fs=14" +"' class='selectTag-profile img-circle'><label>" + doc.name + "</label></div>"
        },
        # {
        #   data: "email",
        #   render:  (val, type, doc) ->
        #     return "<div class='user-email'>" + doc.email + "</div>"
        # }
      ],

      #select:
      #  style: 'single'
      dom: "tp",
      order:[[1,"desc"]]
      extraFields: ["_id", "name", "email", "user"],
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