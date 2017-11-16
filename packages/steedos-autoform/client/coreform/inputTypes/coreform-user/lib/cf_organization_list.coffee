Template.cf_organization_list.helpers


Template.cf_organization_list.onRendered ->
	spaceId = Template.instance().data.spaceId
	is_within_user_organizations = Template.instance().data.is_within_user_organizations
	$("#cf_organizations_tree").on('changed.jstree', (e, data) ->
		console.log("data", data)
		if data.selected.length
			Session.set("cf_selectOrgId", data.selected[0]);

			node = $('#cf_organizations_tree').jstree('get_node', data.selected[0]);

			if node
				Session.set("cf_space", node?.data.spaceId);

				Session.set("cf_orgAndChild", CFDataManager.getOrgAndChild(node, Session.get("cf_selectOrgId")));

			if data?.node?.parent == "#" && data?.node?.state?.opened
				return;

			$("#cf_organizations_tree").jstree('toggle_node', data.selected[0]);

		return
	).jstree
		core:
			themes: {"stripes": true, "variant": "large"},
			three_state: false,
			data: (node, cb) ->
				cb(CFDataManager.getNode(spaceId, node, is_within_user_organizations));

				if node.id != '#'
					Session.set("cf_selectOrgId", node.id);
					Session.set("cf_space", node.data.spaceId);
					Session.set("cf_orgAndChild", CFDataManager.getOrgAndChild(node, Session.get("cf_selectOrgId")));


		plugins: ["wholerow"]


Template.cf_organization_list.events