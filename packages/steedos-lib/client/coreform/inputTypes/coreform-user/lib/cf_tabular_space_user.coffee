    TabularTables.cf_tabular_space_user = new Tabular.Table({
      name: "cf_tabular_space_user",
      collection: db.space_users,
      columns: [
        {
          data: "_id", 
          title: '<input type="checkbox" name="reverse" id="reverse">',
          orderable: false,
          width:'10px',
          render:  (val, type, doc) ->

            inputType = "checkbox";

            if !TabularTables.cf_tabular_space_user.customData?.multiple
              inputType = "radio"

            input = '<input type="' + inputType + '" class="list_checkbox" name="contacts_ids" id="' + doc.user + '" value="' + doc.user + '" data-name="' + doc.name + '" data-email="' + doc.email + '"';

            if TabularTables.cf_tabular_space_user.customData?.defaultValues?.includes(doc.user)
              input += " checked "

            input += ">"
            return input
        },
        {
          data: "name", 
          orderable: false,
          render:  (val, type, doc) ->
            return "<label for='" + doc.user + "' class='for-input'><div class='user-name'><img src='" + Steedos.absoluteUrl() + "/avatar/"+doc.user+"?w=30&h=30&fs=14" +"' class='selectTag-profile img-circle'><font>" + doc.name + "</font></div></label>"
        },
        # {
        #   data: "email",
        #   render:  (val, type, doc) ->
        #     return "<div class='user-email'>" + doc.email + "</div>"
        # }
      ],
      onUnload:() ->
        return console.log("onUnload ok....");
      #select:
      #  style: 'single'
      dom: "tp",
      order:false,
      extraFields: ["_id", "name", "email", "user"],
      lengthChange: false,
      pageLength: 10,
      info: false,
      searching: true,
      responsive: 
        details: false
      autoWidth: false,

      #scrollY:        '400px',
      #scrollCollapse: true,
      pagingType: "numbers"

    });