Meteor.publish 'billing_weixin_pay_code_url', (_id)->
	unless this.userId
		return this.ready()

	unless _id
		return this.ready()

	return db.billing_weixin_pay_code_urls.find({_id: _id});