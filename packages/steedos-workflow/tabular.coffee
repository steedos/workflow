    TabularTables.instances = new Tabular.Table({
      name: "instances",
      collection: db.instances,
      columns: [
        {
          data: "name", 
          render:  (val, type, doc) ->
            modifiedString = moment(doc.modified).format('YYYY-MM-DD');
            modifiedFromNow = moment(doc.modified).fromNow();

            cc_view = "";

            # 当前用户在cc user中，但是不在inbox users时才显示'传阅'文字
            if doc.cc_users?.includes(Meteor.userId()) && !doc.inbox_users?.includes(Meteor.userId()) && Session.get("box") == 'inbox'
              cc_view = "<label class='cc-label'>(" + TAPi18n.__("instance_cc_title") + ")</label> "

            return "<div class='instance-name'>" + doc.name + cc_view +  "</div><div class='instance-modified' title='" + modifiedString + "'>" + modifiedFromNow + "</div><div class='instance-applicant'>" + doc.applicant_name + "</div>"
        },
        {
          data: "modified",
          visible: false,
        },
        {
          data: "applicant_name",
          visible: false,
        },
        {
          data: "applicant_organization_name",
          visible: false,
        }
        # {data: "applicant_name", title: "Applicant"},
        # {
        #   data: "modified",
        #   title: "Modified",
        #   render:  (val, type, doc) ->
        #     if (val instanceof Date) 
        #       modifiedString = moment(val).format('YY-MM-DD');
        #       return "<div class='instance-modified'>" + modifiedString + "</div>"
        #     else 
        #       return "";
        # },
        # {data: "applicant_organization_name", title: "Organization"},
      ],

      #select:
      #  style: 'single'
      dom: "tp",
      order:[[1,"desc"]]
      extraFields: ["form", "flow", "inbox_users", "outbox_users", "state", "space", "applicant", "form_version", "flow_version", "cc_users"],
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