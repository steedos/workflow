Template.steedos_contacts_org_tree.helpers
	isEditable: ()->
		return Session.get('contacts_is_org_admin') && !this.isDisabled

	is_admin: ()->
		return Session.get('contacts_is_org_admin')

	isMobile: ()->
		return Steedos.isMobile();

Template.steedos_contacts_org_tree.onRendered ->
	$('[data-toggle="tooltip"]').tooltip()
	$(document.body).addClass('loading')

	$("#steedos_contacts_org_tree").on('changed.jstree', (e, data) ->
		# 清除整个浏览器的文字选中状态，解决edge浏览器中选中文字造成的一些问题，
		# 比如在space user列表选中一些文字，然后切换到其他组织，会发现edge浏览器上无法拖动了（有权限的情况）等
		window.getSelection()?.removeAllRanges()
		if data.selected.length
			Session.set("contact_showBooks", false)
			Session.set("contact_list_search", false);
			Session.set("contacts_orgId", data.selected[0]);
			ContactsManager.checkOrgAdmin();
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
				console.log "node:#{node}",node
				# this.select_node(node)
				cb(ContactsManager.getOrgNode(node, Session.get('contacts_is_org_admin'))) # 普通用户只显示非隐藏的组织

		plugins: ["wholerow", "search"]

	$("#steedos_contacts_org_tree").on('select_node.jstree', (e, data) ->
		$(".contacts-list-wrapper").hide();
		if $("#contact-list-search-key")
			$("#contact-list-search-key").val("")
			$('#contact-list-search-btn').trigger('click')
	)
	$(document.body).removeClass('loading')



Template.steedos_contacts_org_tree.events
	'click #search-btn': (event, template) ->
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
			orgTree = $.jstree.reference('#steedos_contacts_org_tree')
			parent = orgTree.get_parent(Session.get("contacts_orgId"))
			orgTree.select_node(parent)
			orgTree.refresh()

	'click #contacts_back': (event, template)->
		$(".contacts-list-wrapper").hide()

	"dragenter #steedos_contacts_org_tree .drag-target": (event, template) ->
		target = $(event.target).closest(".drag-target")
		target.children(".jstree-wholerow").addClass("jstree-wholerow-hovered")
		target.children(".jstree-anchor").addClass("jstree-hovered")

	"dragleave #steedos_contacts_org_tree .drag-target": (event, template) ->
		target = $(event.target).closest(".drag-target")
		target.children(".jstree-wholerow").removeClass("jstree-wholerow-hovered")
		target.children(".jstree-anchor").removeClass("jstree-hovered")

	"dragover #steedos_contacts_org_tree .drag-target": (event, template) ->
		event.preventDefault()

	"drop #steedos_contacts_org_tree .drag-target": (event, template) ->
		target = $(event.target).closest(".drag-target")
		from_org_id = Session.get("contacts_orgId")
		to_org_id = target.attr("id")
		space_user_id = Session.get("dragging_contacts_org_user_id")
		Session.set("dragging_contacts_org_user_id","")
		if from_org_id == to_org_id
			toastr.error t("steedos_contacts_error_equal_move_reject")
			return false

		unless space_user_id
			toastr.error t("steedos_contacts_error_space_user_not_found_dragging")
			return false

		Meteor.call 'move_space_users', from_org_id, to_org_id, space_user_id, (error, is_suc) ->
			if is_suc
				toastr.success t('steedos_contacts_move_suc')
			else
				console.error error
				toastr.error(t(error.reason))

		return false
