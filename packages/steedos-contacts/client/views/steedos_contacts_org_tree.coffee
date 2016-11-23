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

	"dragenter .contacts-tree .jstree-node": (event, template) ->
		console.log "jstree-node dragenter"
		target = $(event.target).closest(".jstree-node")
		target.children(".jstree-wholerow").addClass("jstree-wholerow-hovered")
		target.children(".jstree-anchor").addClass("jstree-hovered")

	"dragleave .contacts-tree .jstree-node": (event, template) ->
		console.log "jstree-node dragleave"
		target = $(event.target).closest(".jstree-node")
		target.children(".jstree-wholerow").removeClass("jstree-wholerow-hovered")
		target.children(".jstree-anchor").removeClass("jstree-hovered")

	"dragover .contacts-tree .jstree-node": (event, template) ->
		console.log "jstree-node dragover"
		event.preventDefault()

	"drop .contacts-tree .jstree-node": (event, template) ->
		console.log "jstree-node drop"
		target = $(event.target).closest(".jstree-node")
		# 这里处理拖动后数据变更并保存到数据库的逻辑

		return false
