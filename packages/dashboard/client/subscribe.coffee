Steedos.subsPortal = new SubsManager();

Tracker.autorun (c)->
	if Session.get("spaceId")
		Steedos.subsPortal.subscribe "portal_dashboards", Session.get("spaceId")
		Steedos.subsPortal.subscribe "apps_auths", Session.get("spaceId")
		Steedos.subsPortal.subscribe "apps_auth_users", Session.get("spaceId")


