CFDataManager = {};

// DataManager.organizationRemote = new AjaxCollection("organizations");
// DataManager.spaceUserRemote = new AjaxCollection("space_users");
// DataManager.flowRoleRemote = new AjaxCollection("flow_roles");
CFDataManager.getNode = function (spaceId, node) {

	var orgs;

	myContactsLimit = Steedos.my_contacts_limit
	if (node.id == '#') {
		if (myContactsLimit && myContactsLimit.isLimit) {
			var uOrgs = db.organizations.find({space: spaceId, users: Meteor.userId()}).fetch();
			var _ids = uOrgs.getProperty("_id");
			var outsideOrganizations = myContactsLimit.outside_organizations;
			//当前用户所属组织自身存在的父子包含关系，及其与额外外部组织之间父子包含关系都要过滤掉
			_ids = _.union(_ids, outsideOrganizations);
			orgs = _.filter(uOrgs, function (org) {
				var parents = org.parents || [];
				return _.intersection(parents, _ids).length < 1;
			});
			if(outsideOrganizations.length){
				// 找出outsideOrganizations中不在orgs中的记录，并额外从服务器把其组织信息抓取到前端
				limitIds = _.difference(outsideOrganizations, orgs.getProperty("_id"));
				limitOrgs = ContactsManager.getOrganizationsByIds(limitIds);
				orgs = _.union(orgs,limitOrgs)
			}
			if (orgs.length > 0) {
				orgs[0].open = true
			}
		} else {
			orgs = CFDataManager.getRoot(spaceId);
		}
	}
	else{
		orgs = CFDataManager.getChild(spaceId || node.data.spaceId, node.id);
	}
	return handerOrg(orgs, node.id);
}


function handerOrg(orgs, parentId) {

	var nodes = new Array();

	orgs.forEach(function (org) {

		var node = new Object();

		node.text = org.name;

		node.data = {};

		node.data.fullname = org.fullname;

		node.data.spaceId = org.space

		node.id = org._id;

		node.state = {};

		if (CFDataManager.getOrganizationModalValue().getProperty("id").includes(node.id)) {
			node.state.selected = true;
		}

		if (org.children && org.children.length > 0) {
			node.children = true;
		}else{
			node.children = false;
		}

		// node.children = true;

		if (org.is_company == true || org.open == true) {
			node.state.opened = true;
			if(CFDataManager.getOrganizationModalValue().length === 0){
				node.state.selected = true;
			}
		} else {
			// node.parent = parentId;
			// node.icon = false;
			// node.icon = "fa fa-users";
		}

		node.parent = parentId;

		node.icon = 'fa fa-sitemap';

		nodes.push(node);
	});
	return nodes;
}


CFDataManager.setContactModalValue = function (value) {
	$("#cf_contact_modal").data("values", value);
	if (value && value instanceof Array) {
		TabularTables.cf_tabular_space_user.customData.defaultValues = value.getProperty("id");
	}
}

CFDataManager.getContactModalValue = function () {
	var value = $("#cf_contact_modal").data("values");
	return value ? value : new Array();
}

CFDataManager.setOrganizationModalValue = function (value) {
	$("#cf_organization_modal").data("values", value);
}

CFDataManager.getOrganizationModalValue = function () {
	var value = $("#cf_organization_modal").data("values");
	return value ? value : new Array();
}

CFDataManager.getSelectedModalValue = function () {
	var val = new Array();
	var instance = $('#cf_organizations_tree').jstree(true);
	var checked = instance.get_selected();

	checked.forEach(function (id) {
		var node = instance.get_node(id);
		val.push({
			id: id,
			name: node.text
		});
	});

	return val;
}


CFDataManager.getCheckedValues = function () {
	var values = new Array();
	$('[name=\'cf_contacts_ids\']').each(function () {
		if (this.checked) {
			values.push({
				id: this.value,
				name: this.dataset.name
			});
		}
	});

	return values;
}


CFDataManager.handerContactModalValueLabel = function () {

	var values = CFDataManager.getContactModalValue();
	var modal = $(".cf_contact_modal");

	var confirmButton, html = '',
		valueLabel, valueLabel_div;

	confirmButton = $('#confirm', modal);

	valueLabel = $('#valueLabel', modal);

	valueLabel_div = $('#valueLabel_div', modal);

	valueLabel_ui = $('#valueLabel_ui', modal);

	if (values.length > 0) {

		values.forEach(function (v) {
			return html = html + '\u000d\n<li data-value="' + v.id + '" data-name="' + v.name + '"><span>' + v.name + '</span><a href="#" class="js-remove value-label-remove" tabindex="-1" data-value="' + v.id + '">×</a></li>';
		});
		valueLabel.html(html);
		valueLabel_ui.css("white-space", "initial");
		valueLabel_ui = $('#valueLabel_ui', $(".cf_contact_modal"));

		change_valueLabel_ui = function(){
			if (valueLabel_ui.height() > 46 || valueLabel_ui.height() < 0) {
				valueLabel_ui.css("white-space", "nowrap");
			} else {
				valueLabel_ui.css("white-space", "initial");
			}
		};

		change_valueLabel_ui()

		setTimeout(change_valueLabel_ui, 30);

		var selectUsersList = Sortable.create(valueLabel[0], {
			group: 'words',
			animation: 150,
			filter: '.js-remove',
			onFilter: function (evt) {
				var el = selectUsersList.closest(evt.item)

				var val = CFDataManager.getContactModalValue();

				var index = val.getProperty("id").indexOf(el.dataset.value)

				if (index >= 0) {
					if ($("#" + el.dataset.value).val()) {

						$("#" + el.dataset.value).click()

					} else {

						val.remove(index)

						CFDataManager.setContactModalValue(val);

						CFDataManager.handerContactModalValueLabel();
					}

				}
			},
			onEnd: function (event) {
				var labelValues;
				labelValues = [];
				$('#valueLabel li').each(function () {
					return labelValues.push({
						id: this.dataset.value,
						name: this.dataset.name
					});
				});
				CFDataManager.setContactModalValue(labelValues);
			}
		});

		valueLabel_div.show();
		confirmButton.html(confirmButton.prop("title") + "(" + values.length + ")");
	} else {
		confirmButton.html(confirmButton.prop("title"));
		valueLabel_div.hide();
	}
}

CFDataManager.handerOrganizationModalValueLabel = function () {

	var values = CFDataManager.getOrganizationModalValue();
	var modal = $(".cf_organization_modal");

	var confirmButton, html = '',
		valueLabel, valueLabel_div;

	confirmButton = $('#confirm', modal);

	valueLabel = $('#valueLabel', modal);

	valueLabel_div = $('#valueLabel_div', modal);

	valueLabel_ui = $('#valueLabel_ui', modal);

	if (values.length > 0) {
		values.forEach(function (v) {
			return html = html + '\u000d\n<li data-value="' + v.id + '" data-name="' + v.name + '" data-fullname="' + v.fullname + '"><span>' + v.name + '</span><a href="#" class="js-remove value-label-remove" tabindex="-1" data-value="' + v.id + '">×</a></li>';
		});
		valueLabel.html(html);
		valueLabel_ui.css("white-space", "initial");
		valueLabel_ui = $('#valueLabel_ui', $(".cf_organization_modal"));

		if (valueLabel_ui.height() > 46 || valueLabel_ui.height() < 0) {
			valueLabel_ui.css("white-space", "nowrap");
		} else {
			valueLabel_ui.css("white-space", "initial");
		}

		var selectOrgsList = Sortable.create(valueLabel[0], {
			group: 'words',
			animation: 150,
			filter: '.js-remove',
			onFilter: function (evt) {
				var el = selectOrgsList.closest(evt.item)

				var val = CFDataManager.getOrganizationModalValue();

				var index = val.getProperty("id").indexOf(el.dataset.value)

				if (index >= 0) {

					var cf_org_jstree = $("#cf_organizations_tree").jstree();

					var org_node = cf_org_jstree.get_node(el.dataset.value)

					if(org_node){
						Template.cf_organization.conditionalselect(org_node)
						$("#cf_organizations_tree").jstree("uncheck_node", org_node.id)
					}else{
						val.remove(index)

						CFDataManager.setOrganizationModalValue(val);

						CFDataManager.handerOrganizationModalValueLabel();
					}
				}
			},
			onEnd: function (event) {
				var labelValues;
				labelValues = [];
				$('#valueLabel li').each(function () {
					return labelValues.push({
						id: this.dataset.value,
						name: this.dataset.name,
						fullname: this.dataset.fullname
					});
				});
				CFDataManager.setOrganizationModalValue(labelValues);
			}
		});

		valueLabel_div.show();
		confirmButton.html(confirmButton.prop("title") + "(" + values.length + ")");
	} else {
		confirmButton.html(confirmButton.prop("title"));
		valueLabel_div.hide();
	}
}


CFDataManager.getRoot = function (spaceId) {

	var query = {is_company: true}

	if(spaceId){
		query.space = spaceId
	}else{
		user_spaces = db.spaces.find().fetch().getProperty("_id")

		query.space = {$in: user_spaces}
	}

	return SteedosDataManager.organizationRemote.find(query, {
		fields: {
			_id: 1,
			name: 1,
			space: 1,
			fullname: 1,
			parent: 1,
			children: 1,
			childrens: 1,
			is_company: 1,
		}
	});
};

CFDataManager.getOrganizationsByIds = function(ids) {
	var query = {
		_id: {$in: ids},
		hidden: {$ne: true}
	};
	var showHiddenOrg = false;
	if(!Meteor.settings.public || !Meteor.settings.public.coreform|| !Meteor.settings.public.coreform.show_hidden_organizations){
		showHiddenOrg = true;
	}
	if(showHiddenOrg)
		delete query.hidden
	var childs = SteedosDataManager.organizationRemote.find(query, {
		fields: {
			_id: 1,
			name: 1,
			fullname: 1,
			parent: 1,
			children: 1,
			childrens: 1,
			hidden: 1,
			sort_no: 1,
			admins: 1
		},
		sort: {
			sort_no: -1,
			name: 1
		}
	});
	return childs;
}

CFDataManager.getChild = function (spaceId, parentId) {

	var query ={
		parent: parentId,
		space: spaceId
	}

	if(!Meteor.settings.public || !Meteor.settings.public.coreform|| !Meteor.settings.public.coreform.show_hidden_organizations){
		query.hidden = {$ne: true}
	}

	var childs = SteedosDataManager.organizationRemote.find(query, {
		fields: {
			_id: 1,
			space: 1,
			name: 1,
			fullname: 1,
			parent: 1,
			children: 1,
			childrens: 1,
			sort_no: 1
		},
		sort: {
			sort_no: -1,
			name: 1
		}
	});


	// childs.sort(function (p1, p2) {
	//     if (p1.sort_no == p2.sort_no) {
	//         return p1.name.localeCompare(p2.name);
	//     } else {
	//         if (p1.sort_no < p2.sort_no) {
	//             return 1
	//         } else {
	//             return -1;
	//         }
	//     }
	// });

	return childs;
}


CFDataManager.getSpaceUser = function (userId) {
	if (!userId) {
		return;
	}

	if (typeof userId != "string") {

		return this.getSpaceUsers(userId);

	}

	var spaceUsers = SteedosDataManager.getSpaceUsers(Session.get('spaceId'), userId);
	if (!spaceUsers) {
		return
	}
	;

	var spaceUser = spaceUsers[0];
	if (!spaceUser) {
		return
	}
	;

	return spaceUser;
};

CFDataManager.getSpaceUsers = function (userIds) {

	if ("string" == typeof(userIds)) {
		return [CFDataManager.getSpaceUser(userIds)]
	}

	var users = new Array();
	if (userIds) {
		users = SteedosDataManager.getSpaceUsers(Session.get('spaceId'), userIds);
	}

	return users;
};

CFDataManager.getFormulaSpaceUsers = function (userIds, space) {
	if (!userIds)
		return;
	return CFDataManager.getFormulaSpaceUser(userIds, space);
}

//return {name:'',organization:{fullname:'',name:''},roles:[]}
CFDataManager.getFormulaSpaceUser = function (userId, space) {
	if (userId) {

		var spaceId = Session.get('spaceId');

		if(space === false || true){
			spaceId = null;
		}

		if (userId instanceof Array) {
			return SteedosDataManager.getFormulaUserObjects(spaceId, userId);
		} else {
			return SteedosDataManager.getFormulaUserObjects(spaceId, [userId])[0];
		}
	}
};

CFDataManager.getOrgAndChild = function (node, orgId) {

	var query ={
		space: node.data.spaceId,
		parent: orgId
	}

	if(!Meteor.settings.public || !Meteor.settings.public.coreform|| !Meteor.settings.public.coreform.show_hidden_organizations){
		query.hidden = {$ne: true}
	}

	var childrens = SteedosDataManager.organizationRemote.find(query, {
		fields: {
			_id: 1
		}
	});
	orgs = childrens.getProperty("_id");
	orgs.push(orgId);
	return orgs;
}


CFDataManager.getFormulaOrganizations = function (orgIds, space) {
	if (!orgIds)
		return;
	var orgs = new Array();
	if (orgIds instanceof Array) {
		return SteedosDataManager.getFormulaOrganizations(orgIds, space)
	} else {
		orgs = CFDataManager.getFormulaOrganization(orgIds, space);
	}

	return orgs;
}

CFDataManager.getFormulaOrganization = function (orgId, space) {
	return _.first(SteedosDataManager.getFormulaOrganizations([orgId]), space)
}
