CFDataManager = {};

// DataManager.organizationRemote = new AjaxCollection("organizations");
// DataManager.spaceUserRemote = new AjaxCollection("space_users");
// DataManager.flowRoleRemote = new AjaxCollection("flow_roles");
CFDataManager.getNode = function (spaceId, node, is_within_user_organizations) {

    var orgs;

    if (node.id == '#'){
		if(is_within_user_organizations){
			uOrgs = db.organizations.find({space: spaceId, users: Meteor.userId()}).fetch();

			_ids = uOrgs.getProperty("_id")

			orgs = _.filter(uOrgs, function (org) {
				// var children = org.children || []

                var parents = org.parents || []

				return _.intersection(parents, _ids).length < 1
			})

            if(orgs.length > 0){
			    orgs[0].open = true
            }

		}else{
			orgs = CFDataManager.getRoot(spaceId);
		}
    }
    else
        orgs = CFDataManager.getChild(spaceId, node.id);
    return handerOrg(orgs, node.id);
}


function handerOrg(orgs, parentId) {

    var nodes = new Array();

    orgs.forEach(function (org) {

        var node = new Object();

        node.text = org.name;

        node.data = {};

        node.data.fullname = org.fullname;

        node.id = org._id;

        node.state = {};

        if (CFDataManager.getOrganizationModalValue().getProperty("id").includes(node.id)) {
            node.state.selected = true;
        }

        // if (org.children && org.children.length > 0) {
        //     node.children = true;
        // }

		node.children = true;

        if (org.is_company == true || org.open == true) {
            node.state.opened = true;
			// node.state.selected = true;
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
            return html = html + '\u000d\n<li data-value=' + v.id + ' data-name=' + v.name + '>' + v.name + '</li>';
        });

        valueLabel.html(html);
        valueLabel_ui.css("white-space", "initial");
        valueLabel_ui = $('#valueLabel_ui', $(".cf_contact_modal"));
        if (valueLabel_ui.height() > 46 || valueLabel_ui.height() < 0) {
            valueLabel_ui.css("white-space", "nowrap");
        } else {
            valueLabel_ui.css("white-space", "initial");
        }

        Sortable.create(valueLabel[0], {
            group: 'words',
            animation: 150,
            onRemove: function (event) {
                return console.log('onRemove...');
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
            return html = html + '\u000d\n<li data-value=' + v.id + ' data-name=' + v.name + ' data-fullname= ' + v.fullname + '>' + v.name + '</li>';
        });
        valueLabel.html(html);
        valueLabel_ui.css("white-space", "initial");
        valueLabel_ui = $('#valueLabel_ui', $(".cf_organization_modal"));

        if (valueLabel_ui.height() > 46 || valueLabel_ui.height() < 0) {
            valueLabel_ui.css("white-space", "nowrap");
        } else {
            valueLabel_ui.css("white-space", "initial");
        }

        Sortable.create(valueLabel[0], {
            group: 'words',
            animation: 150,
            onRemove: function (event) {
                return console.log('onRemove...');
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
    return SteedosDataManager.organizationRemote.find({
        is_company: true,
		space: spaceId
    }, {
        fields: {
            _id: 1,
            name: 1,
            fullname: 1,
            parent: 1,
            children: 1,
            childrens: 1,
            is_company: 1,
        }
    });
};


CFDataManager.getChild = function (spaceId, parentId) {
    var childs = SteedosDataManager.organizationRemote.find({
        parent: parentId,
		space: spaceId,
        hidden: {$ne: true}
    }, {
        fields: {
            _id: 1,
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

CFDataManager.getFormulaSpaceUsers = function (userIds) {
    if (!userIds)
        return;
    return CFDataManager.getFormulaSpaceUser(userIds);
}

//return {name:'',organization:{fullname:'',name:''},roles:[]}
CFDataManager.getFormulaSpaceUser = function (userId) {
    if(Session.get('spaceId') && userId){
        if (userId instanceof Array) {
            return SteedosDataManager.getFormulaUserObjects(Session.get('spaceId'), userId);
        } else {
            return SteedosDataManager.getFormulaUserObjects(Session.get('spaceId'), [userId])[0];
        }
    }
};

CFDataManager.getOrgAndChild = function (orgId) {
    var childrens = SteedosDataManager.organizationRemote.find({
        parents: orgId
    }, {
        fields: {
            _id: 1
        }
    });
    orgs = childrens.getProperty("_id");
    orgs.push(orgId);
    return orgs;
}


CFDataManager.getFormulaOrganizations = function (orgIds) {
    if (!orgIds)
        return;
    var orgs = new Array();
    if (orgIds instanceof Array) {
        orgIds.forEach(function (orgId) {
            orgs.push(CFDataManager.getFormulaOrganization(orgId));
        });

    } else {
        orgs = CFDataManager.getFormulaOrganization(orgIds);
    }

    return orgs;
}

CFDataManager.getFormulaOrganization = function (orgId) {
    var org = SteedosDataManager.organizationRemote.findOne({
        _id: orgId
    }, {
        fields: {
            _id: 1,
            name: 1,
            fullname: 1
        }
    });
    org.id = org._id;
    delete org._id;
    return org;
}
