Steedos.API =
	setAppTitle: (title)->
		Session.set("app_title", title);
		document.title = title;

Steedos.API.setAppTitle("Steedos")