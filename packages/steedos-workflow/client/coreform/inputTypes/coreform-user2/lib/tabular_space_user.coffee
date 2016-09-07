    TabularTables.select_space_users = new Tabular.Table({
      name: "select_space_users",
      collection: db.space_users,
      columns: [
        {
          data: "_id", 
          title: '<input type="checkbox" name="reverse" id="reverse">',
          orderable: false,
          width:'30px',
          render:  (val, type, doc) ->
            return '<input type="checkbox" name="contacts_ids" id="contacts_ids" value="' + doc._id + '" data-name="' + doc.name + '" data-email="' + doc.email + '">'
        },
        {
          data: "name", 
          render:  (val, type, doc) ->
            return "<div class='user-name'>" + doc.name + "</div>"
        },
        {
          data: "email",
          render:  (val, type, doc) ->
            return "<div class='user-email'>" + doc.email + "</div>"
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