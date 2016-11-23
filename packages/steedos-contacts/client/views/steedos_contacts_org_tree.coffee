Template.steedos_contacts_org_tree.helpers
	is_admin: ()->
		return Steedos.isSpaceAdmin()
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
	).jstree
		core:
			themes: { "stripes" : true, "variant" : "large" },
			data:  (node, cb) ->
				# 当展开node时不会选中当前node，所以Session中关联数据不应该变化
				# 只有展开根目录时才默认关联根目录数据
				org = db.organizations.findOne(node.id)
				if org and not org.parent
					Session.set("contacts_orgId", node.id)
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
		if from_org_id == to_org_id
			toastr.error t("steedos_contacts_error_equal_move_reject")
		Meteor.call 'move_space_users', from_org_id, to_org_id, space_user_id, (error, is_suc) ->
			if is_suc
				toastr.success t('steedos_contacts_move_suc')
			else
				console.error error
				toastr.error(error)

		Session.set("dragging_contacts_org_user_id","")
		return false
