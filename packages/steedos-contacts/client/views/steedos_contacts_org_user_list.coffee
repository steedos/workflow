Template.steedos_contacts_org_user_list.helpers 
	showBooksList: ->
		if Session.get("contact_showBooks")
			return true
		return false;
	selector: ->

		is_within_user_organizations = ContactsManager.is_within_user_organizations();

		if Meteor.settings.public?.contacts?.hidden_users
			if Steedos.isSpaceAdmin(Session.get("spaceId"), Meteor.userId())
				query = {space: Session.get("spaceId")}
			else
				query = {space: Session.get("spaceId"), user: {$nin: Meteor.settings.public?.contacts?.hidden_users}}
		else
			query = {space: Session.get("spaceId")}
		if !Session.get("contact_list_search")
			orgId = Session.get("contacts_orgId");
			query.organizations = {$in: [orgId]};
		else
			if is_within_user_organizations
				orgs = db.organizations.find().fetch().getProperty("_id")
				orgs_childs = SteedosDataManager.organizationRemote.find({parents: {$in: orgs}}, {
					fields: {
						_id: 1
					}
				});

				orgs = orgs.concat(orgs_childs.getProperty("_id"))

				query.organizations = {$in: orgs};

		if !Session.get('contacts_is_org_admin')
			query.user_accepted = true
		return query;

	books_selector: ->
		query = {owner: Meteor.userId()};
		if Session.get("contacts_groupId") != "parent"
			query.group = Session.get("contacts_groupId");
		return query;

	is_admin: ()->
		return Session.get('contacts_is_org_admin') && !Session.get("contact_list_search")

	isMobile: ()->
		return Steedos.isMobile();

	canImportUsers: ()->
		if Steedos.isMobile()
			return false
		return true

	getOrgName: ()->
		return SteedosDataManager.organizationRemote.findOne({_id:Session.get("contacts_orgId")},{fields:{name: 1}})?.name;

	isSpaceAdmin: ()->
		return Steedos.isSpaceAdmin(Session.get("spaceId"));

Template.steedos_contacts_org_user_list.events
	'click #reverse': (event, template) ->
		$('input[name="contacts_ids"]', $("#contacts_list")).each ->
			$(this).prop('checked', event.target.checked).trigger('change')

	'change .contacts-list-checkbox': (event, template) ->

		target = event.target;

		values = ContactsManager.getContactModalValue();

		if target.checked == true
			if values.getProperty("email").indexOf(target.dataset.email) < 0
				values.push({id: target.value, name: target.dataset.name, email: target.dataset.email});
		else
			values.remove(values.getProperty("email").indexOf(target.dataset.email))

		ContactsManager.setContactModalValue(values);

		ContactsManager.handerContactModalValueLabel();

	'click #contact-list-search-btn': (event, template) ->
		if $("#contact-list-search-key").val()
			Session.set("contact_list_search", true)
		else
			Session.set("contact_list_search", false)
		dataTable = $(".datatable-steedos-contacts").DataTable();
		dataTable.search(
			$("#contact-list-search-key").val(),
		).draw();

	# 'click #steedos_contacts_org_user_list_edit_btn': (event, template) ->
	# 	event.stopPropagation()
	# 	AdminDashboard.modalEdit 'space_users', event.currentTarget.dataset.id

	# 'click #steedos_contacts_org_user_list_remove_btn': (event, template) ->
	# 	event.stopPropagation()
	# 	AdminDashboard.modalDelete 'space_users', event.currentTarget.dataset.id

	'click #steedos_contacts_invite_users_btn': (event, template) ->
		Modal.show('steedos_contacts_invite_users_modal')

	'click #steedos_contacts_show_orgs': (event, template)->
		listWrapper = $(".contacts-list-wrapper")
		if listWrapper.is(":hidden")
			listWrapper.show();
		else
			listWrapper.hide();

	'click .datatable-steedos-contacts tbody tr[data-id]': (event, template)->
		Modal.show('steedos_contacts_space_user_info_modal', {targetId: event.currentTarget.dataset.id})

	'selectstart #contacts_list .drag-source': (event, template)->
		return false

	'dragstart #contacts_list .drag-source': (event, template)->
		event.originalEvent.dataTransfer.setData("Text","")
		draggingId = $(event.currentTarget).data("id")
		Session.set("dragging_contacts_org_user_id",draggingId)
		$(event.currentTarget).addClass("drag-source-moving")
		orgTree = $("#steedos_contacts_org_tree")
		orgTree.find(".jstree-node").addClass("drag-target")
		event.originalEvent.dataTransfer.effectAllowed = "move"
		cursorIcon = $('<img src="data:image/png;base64,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" />');
		event.originalEvent.dataTransfer.setDragImage?(cursorIcon[0], 16, 15)

	'dragend #contacts_list .drag-source': (event, template)->
		$(event.currentTarget).removeClass("drag-source-moving")
		return false


	'click #steedos_contacts_import_users_btn': (event, template)->
		if !Steedos.isPaidSpace()
			Steedos.spaceUpgradedModal()
			return;

		Modal.show("import_users_modal");

	'click #steedos_contacts_export_users_btn': (event, template)->

		spaceId = Session.get("spaceId")
		orgId = Session.get("contacts_orgId")
		if spaceId and orgId
			uobj = {}
			uobj["X-User-Id"] = Meteor.userId()
			uobj["X-Auth-Token"] = Accounts._storedLoginToken()
			uobj.space_id = spaceId
			uobj.org_id = orgId
			url = Steedos.absoluteUrl() + "api/contacts/export/space_users?" + $.param(uobj)
			window.open(url, '_parent', 'EnableViewPortScale=yes')

Template.steedos_contacts_org_user_list.onRendered ->
	$('[data-toggle="tooltip"]').tooltip()
	
	TabularTables.steedosContactsOrganizations.customData = @data
	TabularTables.steedosContactsBooks.customData = @data
	
	ContactsManager.setContactModalValue(@data.defaultValues);

	ContactsManager.handerContactModalValueLabel();
	$("#contact_list_load").hide();
