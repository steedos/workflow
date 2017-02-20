db.portal_dashboards.adminConfig = 
    icon: "globe"
    color: "blue"
    tableColumns: [
        {name: "name"}
        {name: "modified"}
    ]
    selector: Admin.selectorCheckSpaceAdmin

db.apps_auths.adminConfig = 
    icon: "globe"
    color: "blue"
    tableColumns: [
        {name: "name"}
        {name: "title"}
        {name: "modified"}
    ]
    selector: Admin.selectorCheckSpaceAdmin

db.apps_auth_users.adminConfig = 
    icon: "globe"
    color: "blue"
    tableColumns: [
        {name: "auth_name"}
        {name: "user_name"}
        {name: "login_name"}
        {name: "modified"}
    ]
    selector: {space: -1}


Meteor.startup ->

    @portal_dashboards = db.portal_dashboards
    @apps_auths = db.apps_auths
    @apps_auth_users = db.apps_auth_users
    AdminConfig?.collections_add
        portal_dashboards: db.portal_dashboards.adminConfig
        apps_auths: db.apps_auths.adminConfig
        apps_auth_users: db.apps_auth_users.adminConfig


if Meteor.isClient
    Meteor.startup ->
        Tracker.autorun ->
            if Meteor.userId() and Session.get("spaceId")
                AdminTables["apps_auth_users"]?.selector = {space: Session.get("spaceId"),user:Meteor.userId()}

