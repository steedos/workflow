getBrowserLocale = ()->
	l = window.navigator.userLanguage || window.navigator.language || 'en'
	if l.indexOf("zh") >=0
		locale = "zh-cn"
	else
		locale = "en-us"
	return locale

Tracker.autorun ()->
	Session.set("steedos-locale", getBrowserLocale())
	if Meteor.user()
		if Meteor.user().locale
			Session.set("steedos-locale",Meteor.user().locale)



Tracker.autorun ()->
	if Session.get("steedos-locale") == "zh-cn"
		TAPi18n.setLanguage("zh-CN")
	else
		TAPi18n.setLanguage("en")

	
	SimpleSchema.prototype.i18n = (prefix) ->
		self = this
		_.each(self._schema, (value, key) ->
			if (!value) 
				return
			if !self._schema[key].label
				self._schema[key].label = ()->
					return t(prefix + "_" + key.replace(/\./g,"_"))
		)

Meteor.startup ->
	Tracker.autorun ->
		lang = Session.get("steedos-locale")

		$.extend true, $.fn.dataTable.defaults, 
			language: 
				"decimal":        t("dataTables.decimal"),
				"emptyTable":     t("dataTables.emptyTable"),
				"info":           t("dataTables.info"),
				"infoEmpty":      t("dataTables.infoEmpty"),
				"infoFiltered":   t("dataTables.infoFiltered"),
				"infoPostFix":    t("dataTables.infoPostFix"),
				"thousands":      t("dataTables.thousands"),
				"lengthMenu":     t("dataTables.lengthMenu"),
				"loadingRecords": t("dataTables.loadingRecords"),
				"processing":     t("dataTables.processing"),
				"search":         t("dataTables.search"),
				"zeroRecords":    t("dataTables.zeroRecords"),
				"paginate":
					"first":      t("dataTables.paginate.first"),
					"last":       t("dataTables.paginate.last"),
					"next":       t("dataTables.paginate.next"),
					"previous":   t("dataTables.paginate.previous")
				"aria": 
					"sortAscending":  t("dataTables.aria.sortAscending"),
					"sortDescending": t("dataTables.aria.sortDescending")
				
		_.each Tabular.tablesByName, (table) ->
			_.each table.options.columns, (column) ->
				if (!column.data || column.data == "_id")
					return
				column.sTitle = t("" + table.collection._name + "_" + column.data.replace(/\./g,"_"));
				if !table.options.language
					table.options.language = {}
				table.options.language.zeroRecords = t("dataTables.zero") + t(table.collection._name) 	
		