Meteor.methods
	selectGetUsers: (options) ->
		this.unblock();
		searchText = options.searchText;
		values = options.values;
		users = []
		if (searchText)
			users = Calendar.find(
				{
					$or: [
						member: {$regex: searchText}
						"profile.name": {$regex: searchText}
						"emails.address": {$regex: searchText}
					]
				}, 
				{limit: 5}
			).fetch()
		else if (values.length) 
			users = Meteor.users.find({_id: {$in: values}}).fetch();	
		users = Meteor.users.find({}, {limit: 5}).fetch();
		
		results = []
		_.each users, (user)->
			if user.profile?.name
				label = user.profile.name
			else if user.username
				label = user.username
			else
				label = user._id

			if user.emails[0].address?
				label = label + "(" + user.emails[0].address + ")"
				
			results.push
				label: label
				value: user._id
 
		return results



# 从calendar的members中选择成员（未实现）
	inviteGetUsers: (options) ->
		searchText = options.searchText;
		values = options.values;
		users = []
		if (searchText)
			users = Meteor.users.find(
				{
					$or: [
						{"username": {$regex: searchText}},
						{"name": {$regex: searchText}},
						{"emails.address": {$regex: searchText}}
					]
				}, 
				{limit: 10}
			).fetch()
		else if (values.length) 
			users = Meteor.users.find({_id: {$in: values}}).fetch();	
		else
			return []

		results = []
		_.each users, (user)->
			if user.name
				label = user.name
			else if user.username
				label = user.username
			else
				label = user._id

			if user.emails[0].address?
				label = label + "(" + user.emails[0].address + ")"
				
			results.push
				label: label
				value: user._id
 
		return results