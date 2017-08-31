Template.steedos_contacts_org_list.helpers
	orgs: ->
		currentOrgId = Session.get('contacts_orgId')
		if currentOrgId
			return ContactsManager.getOrgNode({id:currentOrgId})
		else
			return []


Template.steedos_contacts_org_list.onRendered ->
	$(document.body).addClass('loading')
	rootOrg = ContactsManager.getOrgNode({id:"#"})[0]
	if rootOrg
		Session.set("contacts_orgId", rootOrg.id)


	# $("#steedos_contacts_org_tree").on('changed.jstree', (e, data) ->
	# 	# 清除整个浏览器的文字选中状态，解决edge浏览器中选中文字造成的一些问题，
	# 	# 比如在space user列表选中一些文字，然后切换到其他组织，会发现edge浏览器上无法拖动了（有权限的情况）等
	# 	window.getSelection()?.removeAllRanges()
	# 	if data.selected.length
	# 		Session.set("contact_showBooks", false)
	# 		Session.set("contact_list_search", false);
	# 		Session.set("contacts_orgId", data.selected[0]);
	# 		ContactsManager.checkOrgAdmin();
	# 	return
	# ).on('ready.jstree',(e, data) ->
	# 	ins = data.instance
	# 	rootNode = data.instance.get_node("#")
	# 	if rootNode.children.length
	# 		firstNode = rootNode.children[0]
	# 		ins.select_node(firstNode)
	# ).jstree
	# 	core:
	# 		multiple:false,
	# 		themes: { "stripes" : true, "variant" : "large" },
	# 		data:  (node, cb) ->
	# 			# this.select_node(node)
	# 			cb(ContactsManager.getOrgNode(node, Session.get('contacts_is_org_admin'))) # 普通用户只显示非隐藏的组织

	# 	plugins: ["wholerow", "search"]

	# $("#steedos_contacts_org_tree").on('select_node.jstree', (e, data) ->
	# 	$(".contacts-list-wrapper").hide();
	# 	if $("#contact-list-search-key")
	# 		$("#contact-list-search-key").val("")
	# 		$('#contact-list-search-btn').trigger('click')
	# )
	$(document.body).removeClass('loading')



Template.steedos_contacts_org_list.events
	'click .contacts-org-list-item': (event, template) ->
		Session.set("contacts_orgId", event.currentTarget.dataset.id)
