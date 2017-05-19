Template.cf_organization_list.helpers


Template.cf_organization_list.onRendered ->
	spaceId = Template.instance().data.spaceId
	is_within_user_organizations = Template.instance().data.is_within_user_organizations
	$("#cf_organizations_tree").on('changed.jstree', (e, data) ->
		if data.selected.length
			Session.set("cf_selectOrgId", data.selected[0]);
			Session.set("cf_orgAndChild", CFDataManager.getOrgAndChild(Session.get("cf_selectOrgId")));

			if data?.node?.parent == "#" && data?.node?.state?.opened
				return;

			$("#cf_organizations_tree").jstree('toggle_node', data.selected[0]);

		return
	).jstree
		core:
			themes: {"stripes": true, "variant": "large"},
			three_state: false
			data: (node, cb) ->
				Session.set("cf_selectOrgId", node.id);
				cb(CFDataManager.getNode(spaceId, node, is_within_user_organizations));
				Session.set("cf_orgAndChild", CFDataManager.getOrgAndChild(Session.get("cf_selectOrgId")));

		plugins: ["wholerow"]


Template.cf_organization_list.events