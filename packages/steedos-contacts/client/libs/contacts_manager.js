ContactsManager = {};


ContactsManager.is_within_user_organizations = function () {

	if(Steedos.isSpaceAdmin(Session.get("spaceId"))){
		return false
	}

	var is_within_user_organizations, ref, ref1;

	is_within_user_organizations = ((ref = Meteor.settings["public"]) != null ? (ref1 = ref.workflow) != null ? ref1.user_selection_within_user_organizations : void 0 : void 0) || false;

    return is_within_user_organizations
}

ContactsManager.getOrgNode = function(node, showHiddenOrg) {
    var orgs;

	var is_within_user_organizations = ContactsManager.is_within_user_organizations();

    if (node.id == '#')
        if(is_within_user_organizations){
			uOrgs = db.organizations.find({space: Session.get("spaceId"), users: Meteor.userId()}).fetch();

			_ids = uOrgs.getProperty("_id")

			orgs = _.filter(uOrgs, function (org) {
				// var children = org.children || []

				var parents = org.parents || []

				return _.intersection(parents, _ids).length < 1
			})

			if (orgs.length > 0) {
				orgs[0].open = true
			}

        }else{
			orgs = ContactsManager.getRoot();
        }
    else
        orgs = ContactsManager.getChild(node.id, showHiddenOrg);

    return handerOrg(orgs, node.id);
}

ContactsManager.getBookNode = function(node) {
    var nodes = new Array();
    if (node.id == "#") {
        var n = new Object();
        n.text = TAPi18n.__("contacts_personal_contacts");
        n.id = "root";
        n.icon = 'ion ion-android-contacts';
        n.children = true;
        n.state = {
            opened: true
        };
        nodes.push(n);
    } else {
        var groups = db.address_groups.find().fetch();
        groups.forEach(function(g) {
            var n = new Object();
            n.text = g.name;
            n.id = g._id;
            n.icon = 'ion ion-android-contacts';
            nodes.push(n);
        });
    }

    return nodes;
}

function handerOrg(orgs, parentId) {

    var nodes = new Array();

    orgs.forEach(function(org) {

        var node = new Object();

        node.text = org.name;

        node.id = org._id;

        node.li_attr = {}; 

        if (org.children && org.children.length > 0) {
            node.children = true;
        }

        if (!org.is_company) {
            node.parent = org.parent;
            node.icon = 'fa fa-sitemap';
        } else {
            node.state = {
                opened: true
            };
            node.icon = 'fa fa-sitemap';
        }
        if(org.hidden){
            node.li_attr = {
                class:"text-muted"
            };
        }

        node.li_attr["data-admins"] = org.admins;

		node.parent = parentId;

        nodes.push(node);
    });

    return nodes;
}


ContactsManager.getRoot = function() {
    return SteedosDataManager.organizationRemote.find({
        is_company: true
    }, {
        fields: {
            _id: 1,
            name: 1,
            fullname: 1,
            parent: 1,
            children: 1,
            childrens: 1,
            is_company: 1,
            admins: 1
        }
    });
};


ContactsManager.getChild = function(parentId,showHiddenOrg) {
    var query = {
        parent: parentId,
        hidden: {$ne: true}
    }

    if(showHiddenOrg)
        query = {parent: parentId}

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


    // childs.sort(function(p1, p2) {
    //     if (p1.sort_no == p2.sort_no) {
    //         return p1.name.localeCompare(p2.name);
    //     } else {
    //         if (p1.sort_no < p2.sort_no) {
    //             return 1
    //         } else {
    //             return -1
    //         }
    //     }
    // });

    return childs;
}

ContactsManager.getOrgAndChild = function(orgId) {
    var childrens = SteedosDataManager.organizationRemote.find({
        parents: orgId
    }, {
        fields: {
            _id: 1,
            admins: 1
        }
    });
    orgs = childrens.getProperty("_id");
    orgs.push(orgId);
    return orgs;
}

/*
 * 查询当前部门及其自部门下的所有用户
 */
ContactsManager.getContacts = function(orgId) {
    if (orgId == "#") return;

    var childrens = db.organizations.find({
        parents: orgId
    }, {
        fields: {
            _id: 1
        }
    }).fetch();

    orgs = childrens.getProperty("_id");

    orgs.push(orgId);

    page = 0

    page_size = 20;

    return db.space_users.find({
        organization: {
            $in: orgs
        }
    }, {
        fields: {
            _id: 1,
            name: 1,
            email: 1
        },
        skip: page * page_size,
        limit: page_size
    }).fetch();
}

ContactsManager.getContactModalValue = function() {
    var value = $("#contacts_list").data("values");
    return value ? value : new Array();
}

ContactsManager.setContactModalValue = function(value) {
    $("#contacts_list").data("values", value);
}

ContactsManager.handerContactModalValueLabel = function() {

    var values = ContactsManager.getContactModalValue();
    var modal = $(".steedos-contacts");

    if (!modal || modal.length < 1) {
        return;
    }

    var confirmButton, html = '',
        valueLabel, valueLabel_div;

    confirmButton = $('#confirm', modal);

    valueLabel = $('#valueLabel', modal);

    valueLabel_div = $('#valueLabel_div', modal);

    valueLabel_ui = $('#valueLabel_ui', modal);

    if (values.length > 0) {
        values.forEach(function(v) {
            return html = html + '\u000d\n<li data-value=' + v.id + ' data-name=' + v.name + '>' + v.name + '</li>';
        });
        valueLabel.html(html);

        if (valueLabel_ui.height() > 46) {
            valueLabel_ui.css("white-space", "nowrap");
        } else {
            valueLabel_ui.css("white-space", "initial");
        }

        Sortable.create(valueLabel[0], {
            group: 'words',
            animation: 150,
            onRemove: function(event) {
                return console.log('onRemove...');
            },
            onEnd: function(event) {
                var labelValues;
                labelValues = [];
                $('#valueLabel li').each(function() {
                    return labelValues.push({
                        id: this.dataset.value,
                        name: this.dataset.name
                    });
                });
                ContactsManager.setContactModalValue(labelValues);
            }
        });

        valueLabel_div.show();
        confirmButton.html(confirmButton.prop("title") + " ( " + values.length + " ) ");
    } else {
        confirmButton.html(confirmButton.prop("title"));
        valueLabel_div.hide();
    }
}

//注意该函数不能在autorun中调用，因为会引起切换工作区时调用两次autorun，从而造成右侧组织构架树可能（即概率性的bug）不同步刷新。
ContactsManager.checkOrgAdmin = function(){
    var currentOrg, orgId, ref, userId;
    Session.set('contacts_is_org_admin', false);
    orgId = Session.get('contacts_orgId');
    if (!orgId) {
        return;
    }
    if (Steedos.isSpaceAdmin()) {
        Session.set('contacts_is_org_admin', true);
        return;
    }
    currentOrg = db.organizations.findOne(orgId);
    userId = Steedos.userId();
    if (currentOrg != null ? (ref = currentOrg.admins) != null ? ref.includes(userId) : void 0 : void 0) {
        Session.set('contacts_is_org_admin', true);
        return;
    }
    Meteor.call('check_org_admin', orgId, function(error, is_suc) {
        if (is_suc) {
            return Session.set('contacts_is_org_admin', true);
        } else if (error) {
            console.error(error);
            return toastr.error(t(error.reason));
        }
    });
}