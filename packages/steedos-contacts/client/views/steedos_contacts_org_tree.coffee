Template.steedos_contacts_org_tree.helpers
	is_admin: ()->
		if Steedos.isSpaceAdmin()
			return true
		currentOrgId = Session.get('contacts_orgId')
		unless currentOrgId
			return false
		currentOrg = SteedosDataManager.organizationRemote.findOne(currentOrgId)
		unless currentOrg
			return false
		userId = Steedos.userId()
		else if currentOrg?.admins?.includes(userId)
			return true
		else
			if currentOrg?.parent and SteedosDataManager.organizationRemote.findOne({_id:{$in:currentOrg.parents}, admins:{$in:[userId]}})
				return true
			else
				return false

	isMobile: ()->
		return Steedos.isMobile();

Template.steedos_contacts_org_tree.onRendered ->
	$('[data-toggle="tooltip"]').tooltip()
	$(document.body).addClass('loading')
	# 防止首次加载时，获得不到node数据。
	# Steedos.subsSpace.subscribe 'organizations', Session.get("spaceId"), onReady: ->
	# this.autorun ()->
	#   if Steedos.subsSpace.ready("organizations")

	console.log "loaded_organizations ok..."
	$("#steedos_contacts_org_tree").on('changed.jstree', (e, data) ->
		if data.selected.length
			# console.log 'The selected node is::: ' + data.instance.get_node(data.selected[0]).text
			Session.set("contact_showBooks", false)
			Session.set("contacts_orgId", data.selected[0]);
		return
	).on('ready.jstree',(e, data) ->
		ins = data.instance
		rootNode = data.instance.get_node("#")
		if rootNode.children.length
			firstNode = rootNode.children[0]
			ins.select_node(firstNode)
	).jstree
		core:
			multiple:false,
			themes: { "stripes" : true, "variant" : "large" },
			data:  (node, cb) ->
				# this.select_node(node)
				cb(ContactsManager.getOrgNode(node,true))

		plugins: ["wholerow", "search"]

	$("#steedos_contacts_org_tree").on('select_node.jstree', (e, data) ->
		$(".contacts-list-wrapper").hide();
	)


	$(document.body).removeClass('loading')



Template.steedos_contacts_org_tree.events
	'click #search-btn': (event, template) ->
		console.log 'click search-btn'
		$('#steedos_contacts_org_tree').jstree(true).search($("#search-key").val())

	'click #steedos_contacts_org_tree_add_btn': (event, template) ->
		doc = { parent: Session.get('contacts_orgId') }
		AdminDashboard.modalNew 'organizations', doc, ()->
			$.jstree.reference('#steedos_contacts_org_tree').refresh()

	'click #steedos_contacts_org_tree_edit_btn': (event, template) ->
		AdminDashboard.modalEdit 'organizations', Session.get('contacts_orgId'), ()->
			$.jstree.reference('#steedos_contacts_org_tree').refresh()

	'click #steedos_contacts_org_tree_remove_btn': (event, template) ->
		AdminDashboard.modalDelete 'organizations', Session.get('contacts_orgId'), ()->
			$.jstree.reference('#steedos_contacts_org_tree').refresh()

	'click #contacts_back': (event, template)->
		$(".contacts-list-wrapper").hide()

	"dragenter #steedos_contacts_org_tree .drag-target": (event, template) ->
		console.log "drag-target dragenter"
		target = $(event.target).closest(".drag-target")
		target.children(".jstree-wholerow").addClass("jstree-wholerow-hovered")
		target.children(".jstree-anchor").addClass("jstree-hovered")

	"dragleave #steedos_contacts_org_tree .drag-target": (event, template) ->
		console.log "drag-target dragleave"
		target = $(event.target).closest(".drag-target")
		target.children(".jstree-wholerow").removeClass("jstree-wholerow-hovered")
		target.children(".jstree-anchor").removeClass("jstree-hovered")

	"dragover #steedos_contacts_org_tree .drag-target": (event, template) ->
		console.log "drag-target dragover"
		event.preventDefault()

	"drop #steedos_contacts_org_tree .drag-target": (event, template) ->
		console.log "drag-target drop"
		target = $(event.target).closest(".drag-target")
		from_org_id = Session.get("contacts_orgId")
		to_org_id = target.attr("id")
		space_user_id = Session.get("dragging_contacts_org_user_id")
		Session.set("dragging_contacts_org_user_id","")
		if from_org_id == to_org_id
			toastr.error t("steedos_contacts_error_equal_move_reject")
			return false

		Meteor.call 'move_space_users', from_org_id, to_org_id, space_user_id, (error, is_suc) ->
			if is_suc
				toastr.success t('steedos_contacts_move_suc')
			else
				console.error error
				toastr.error(error)

		return false
