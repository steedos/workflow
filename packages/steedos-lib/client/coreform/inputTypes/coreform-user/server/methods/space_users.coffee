Meteor.methods
	getCFOptionSpaceUsers: (options)->

		uid = this.userId;

		searchText = options.searchText;

		values = options.values;

		params = options.params

		if params
			params = JSON.parse(params)

		console.log "values" , values

		console.log "params.spaceId", params.spaceId
		console.log "params.selected", params.selected
		console.log "params.query", params.query

		spaceId = params?.spaceId

		if !spaceId
			return []

		spaceUser = db.space_users.findOne({space: spaceId, user: uid});

		if !spaceUser
			return []

		query = params?.query || {}

		selected = params?.selected || []

		options = new Array();

		users = new Array();


		if searchText
			pinyin = /^[a-zA-Z\']*$/.test(searchText)
			if (pinyin && searchText.length > 8) || (!pinyin && searchText.length > 1)
				console.log "searchText is #{searchText}"

				query.$or = [{name: {$regex: searchText}}, {email: {$regex: searchText}}, {mobile: {$regex: searchText}}]

				query._id = {$nin: selected}

				users = db.space_users.find(query, {limit: 10, fields: {name: 1, email: 1, mobile: 1, user: 1}}).fetch()

		else if values.length
			users = db.space_users.find({user: {$in: values}}, {fields: {name: 1, email: 1, mobile: 1, user: 1}}).fetch();


		users.forEach (u)->
			options.push({label: "#{u.name}", value: u.user});

		console.log "options:", options

		return options;