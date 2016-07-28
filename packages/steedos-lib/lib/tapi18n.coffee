@t = (key, replaces...) ->
	if _.isObject replaces[0]
		return TAPi18n.__ key, replaces
	else
		return TAPi18n.__ key, { postProcess: 'sprintf', sprintf: replaces }

@tr = (key, options, replaces...) ->
	if _.isObject replaces[0]
		return TAPi18n.__ key, options, replaces
	else
		return TAPi18n.__ key, options, { postProcess: 'sprintf', sprintf: replaces }

@trl = (key, options, locale, replaces...) ->
	if locale == "zh-cn"
		locale = "zh-CN"
	
	if _.isObject replaces[0]
		return TAPi18n.__ key, options, locale, replaces
	else
		return TAPi18n.__ key, options, locale, { postProcess: 'sprintf', sprintf: replaces }

@isRtl = (language) ->
	# https://en.wikipedia.org/wiki/Right-to-left#cite_note-2
	return language?.split('-').shift().toLowerCase() in ['ar', 'dv', 'fa', 'he', 'ku', 'ps', 'sd', 'ug', 'ur', 'yi']


datatables_i18n = 
	"en":
		"sEmptyTable":     "",
		"sInfo":           "Showing _START_ to _END_ of _TOTAL_ entries",
		"sInfoEmpty":      "Showing 0 to 0 of 0 entries",
		"sInfoFiltered":   "(filtered from _MAX_ total entries)",
		"sInfoPostFix":    "",
		"sInfoThousands":  ",",
		"sLengthMenu":     "Show _MENU_ entries",
		"sLoadingRecords": "Loading...",
		"sProcessing":     "Processing...",
		"sSearch":         "Search:",
		"sZeroRecords":    "No matching records found",
		"oPaginate": 
			"sFirst":    "First",
			"sLast":     "Last",
			"sNext":     "Next",
			"sPrevious": "Previous"
		"oAria": 
			"sSortAscending":  ": activate to sort column ascending",
			"sSortDescending": ": activate to sort column descending"
		"select" : 
			"rows": "%d row(s) selected"
		
	"zh-CN":
		"sProcessing":   "处理中...",
		"sLengthMenu":   "显示 _MENU_ 项结果",
		"sZeroRecords":  "没有匹配结果",
		"sInfo":         "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
		"sInfoEmpty":    "显示第 0 至 0 项结果，共 0 项",
		"sInfoFiltered": "(由 _MAX_ 项结果过滤)",
		"sInfoPostFix":  "",
		"sSearch":       "搜索:",
		"sUrl":          "",
		"sEmptyTable":     "",
		"sLoadingRecords": "载入中...",
		"sInfoThousands":  ",",
		"oPaginate": 
			"sFirst":    "首页",
			"sPrevious": "上页",
			"sNext":     "下页",
			"sLast":     "末页"
		"oAria": 
			"sSortAscending":  ": 以升序排列此列",
			"sSortDescending": ": 以降序排列此列"
		"select" : 
			"rows": "选中%d行"
	



if Meteor.isClient


	SimpleSchema.prototype.i18n = (prefix) ->
		self = this
		_.each(self._schema, (value, key) ->
			if (!value) 
				return
			if !self._schema[key].label
				self._schema[key].label = ()->
					return t(prefix + "_" + key)
		)

	Tracker.autorun ->
		lang = Session.get("TAPi18n::loaded_lang")

		_.each Tabular.tablesByName, (table) ->
				_.each table.options.columns, (column) ->
					if (!column.data || column.data == "_id")
						return
					column.title = t("" + table.collection._name + "_" + column.data);
				table.options.language = datatables_i18n[lang]
				
		
