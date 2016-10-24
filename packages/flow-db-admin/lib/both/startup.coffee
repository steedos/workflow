@AdminTables = {}

adminTablesDom = '<"box"<"box-header"<"box-toolbar"<"pull-left"<lf>><"pull-right"p>>><"box-body"t>>'

adminEditButton = {
	data: '_id'
	title: 'Edit'
	createdCell: (node, cellData, rowData) ->
		$(node).html(Blaze.toHTMLWithData Template.adminEditBtn, {_id: cellData}, node)
	width: '40px'
	orderable: false
}
adminDelButton = {
	data: '_id'
	title: 'Delete'
	createdCell: (node, cellData, rowData) ->
	 $(node).html(Blaze.toHTMLWithData Template.adminDeleteBtn, {_id: cellData}, node)
	width: '40px'
	orderable: false
}

adminEditDelButtons = [
	adminEditButton,
	adminDelButton
]

defaultColumns = () -> [
  data: '_id',
  title: 'ID'
]


adminTablePubName = (collection) ->
	"admin_tabular_#{collection}"

adminCreateTables = (collections) ->
	_.each collections, (collection, name) ->
		_.defaults collection, {
			showEditColumn: true
			showDelColumn: true
		}

		columns = _.map collection.tableColumns, (column) ->
			if column.template
				createdCell = (node, cellData, rowData) ->
					$(node).html ''
					Blaze.renderWithData(Template[column.template], {value: cellData, doc: rowData}, node)

			data: column.name
			title: column.label
			createdCell: createdCell

		if columns.length == 0
			columns = defaultColumns()

		if collection.showEditColumn
			columns.push(adminEditButton)
		if collection.showDelColumn
			columns.push(adminDelButton)

		AdminTables[name] = new Tabular.Table
			name: name
			collection: adminCollectionObject(name)
			pub: collection.children and adminTablePubName(name)
			sub: collection.sub
			columns: columns
			extraFields: collection.extraFields
			dom: adminTablesDom
			selector: collection.selector
			pageLength: collection.pageLength
			lengthChange: false


adminPublishTables = (collections) ->
	_.each collections, (collection, name) ->
		if not collection.children then return undefined
		Meteor.publishComposite adminTablePubName(name), (tableName, ids, fields) ->
			check tableName, String
			check ids, Array
			check fields, Match.Optional Object

			extraFields = _.reduce collection.extraFields, (fields, name) ->
				fields[name] = 1
				fields
			, {}
			_.extend fields, extraFields

			@unblock()

			find: ->
				@unblock()
				adminCollectionObject(name).find {_id: {$in: ids}}, {fields: fields}
			children: collection.children

Meteor.startup ->
	adminCreateTables AdminConfig?.collections
	adminPublishTables AdminConfig?.collections if Meteor.isServer


	AdminConfig?.collections_add = (collections) ->
		adminCreateTables collections
		adminPublishTables collections if Meteor.isServer
		_.each collections, (collection, name) ->
			AdminConfig.collections[name] = collection
