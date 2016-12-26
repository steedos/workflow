Template.instance_list.helpers

    instances: ->
        return db.instances.find({}, {sort: {modified: -1}});

    boxName: ->
        if Session.get("box")
            return t(Session.get("box"))

    spaceId: ->
        return Session.get("spaceId");

    hasFlowId: ->
        return !!Session.get("flowId");

    selector: ->
        unless Meteor.user()
            return {make_a_bad_selector: 1}
        query = {space: Session.get("spaceId"), flow: Session.get("flowId")}
        box = Session.get("box")
        if box == "inbox"
            query.$or = [{inbox_users: Meteor.userId()}, {cc_users: Meteor.userId()}]
            query.state = {$in: ["pending","completed"]}
            # query.inbox_users = Meteor.userId()
        else if box == "outbox"
            query.outbox_users = Meteor.userId()
        else if box == "draft"
            query.submitter = Meteor.userId()
            query.state = "draft"
        else if box == "pending"
            uid = Meteor.userId()
            query.$or = [{submitter: uid}, {applicant: uid}]
            query.state = "pending"
        else if box == "completed"
            query.submitter = Meteor.userId()
            query.state = "completed"
        else if box == "monitor"
            query.state = {$in: ["pending","completed"]}
            uid = Meteor.userId()
            space = db.spaces.findOne(Session.get("spaceId"))
            if !space
                query.state = "none"

            if !space.admins.contains(uid)
                flow_ids = WorkflowManager.getMyAdminOrMonitorFlows()
                if query.flow
                    if !flow_ids.includes(query.flow)
                        query.$or = [{submitter:uid}, {applicant:uid}, {inbox_users:uid}, {outbox_users:uid}]
                else
                    query.$or = [{submitter:uid}, {applicant:uid}, {inbox_users:uid}, {outbox_users:uid}, {flow: {$in: flow_ids}}]

        else
            query.state = "none"

        query.is_deleted = false

        instance_more_search_selector = Session.get('instance_more_search_selector')
        if (instance_more_search_selector)
            _.keys(instance_more_search_selector).forEach (k)->
                query[k] = instance_more_search_selector[k]

        return query

    enabled_export: ->
        spaceId = Session.get("spaceId");
        if !spaceId
            return;
        space = db.spaces.findOne(spaceId);
        if !space
            return;
        if Session.get("box")=="monitor"
            if space.admins.contains(Meteor.userId())
                return "";
            else
                if Session.get("flowId")
                    flow_ids = WorkflowManager.getMyAdminOrMonitorFlows()
                    if flow_ids.includes(Session.get("flowId"))
                        return ""
                return "display: none;";

    is_display_search_tip: ->
        if Session.get('instance_more_search_selector')
            return ""
        return "display: none;"

    maxHeight: ->
        return Template.instance().maxHeight.get() - 55 + 'px'

    isShowMenu: ->
        if Session.get("box") == 'inbox'
            inboxInstances = InstanceManager.getUserInboxInstances();
            if inboxInstances.length > 0
                return true

        return false;


Template.instance_list.onCreated ->
    self = this;

    self.maxHeight = new ReactiveVar(
        $(window).height() - 55);

    $(window).resize ->
        self.maxHeight?.set($(window).height() - 55);

Template.instance_list.onRendered ->
    #dataTable = $(".datatable-instances").DataTable();
    #dataTable.select();

    node = $(".workflow-menu");
    node.maxHeight?.set($(window).height() - 55);
    $('[data-toggle="tooltip"]').tooltip()
    if !Steedos.isMobile()
        $(".instance-list").perfectScrollbar();

Template.instance_list.events

    'click tbody > tr': (event) ->
        dataTable = $(event.target).closest('table').DataTable();
        row = $(event.target).closest('tr');
        rowData = dataTable.row(event.currentTarget).data();
        if (!rowData)
            return;
        box = Session.get("box");
        spaceId = Session.get("spaceId");

        if row.hasClass('selected')
            row.removeClass('selected');
            FlowRouter.go("/workflow/space/" + spaceId + "/" + box);

        else
            dataTable.$('tr.selected').removeClass('selected');
            row.addClass('selected');
            FlowRouter.go("/workflow/space/" + spaceId + "/" + box + "/" + rowData._id);



    'click .dropdown-menu li a': (event) ->
        InstanceManager.exportIns(event.target.type);

    'keyup #instance_search': (event) ->
        dataTable = $(".datatable-instances").DataTable();
        dataTable.search(
            $('#instance_search').val(),
        ).draw();

    'click [name="show_all_ins"]': (event) ->
        Session.set("flowId", undefined);

    'click [name="create_ins_btn"]': (event) ->
        #判断是否为欠费工作区
        if WorkflowManager.isArrearageSpace()
            toastr.error(t("spaces_isarrearageSpace"));
            return;

        Modal.show("flow_list_box_modal")

    'click [name="show_flows_btn"]': (event) ->
        Modal.show('flow_list_modal')

    'click #instance_more_search': (event, template) ->
        Modal.show("instance_more_search_modal")

    'click #instance_search_tip_close_btn': (event, template) ->
        Session.set("instance_more_search_selector", undefined)
        Session.set("flowId", undefined)
