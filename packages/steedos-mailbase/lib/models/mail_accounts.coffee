db.mail_accounts = new Meteor.Collection('mail_accounts')

db.mail_accounts.allow
	update: (userId, doc, fields, modifier) ->
		return doc.owner == userId;

	insert: (userId, doc, fields, modifier) ->
		return doc.owner == userId;

db.mail_accounts._simpleSchema = new SimpleSchema
	space:
		type: String,
		autoform:
			type: "hidden",
			defaultValue: ->
				return Session.get("spaceId");
	owner:
		type: String,
		autoform:
			type: "hidden",
			defaultValue: ->
				return Meteor.userId();
	email:
		type: String,
		autoform:
			defaultValue: ->
				return Meteor.user().emails?[0]?.address
	password:
		type: String,
		autoform:
			type: "password"

	created:
		type: Date,
		optional: true
	created_by:
		type: String,
		optional: true
	modified:
		type: Date,
		optional: true
	modified_by:
		type: String,
		optional: true


if Meteor.isClient
	db.mail_accounts._simpleSchema.i18n("mail_accounts")

db.mail_accounts.attachSchema(db.mail_accounts._simpleSchema)

if Meteor.isServer

	Mail.cryptIvForMail = "-mail-2016fzb2e8"

	db.mail_accounts.before.insert (userId, doc) ->
		doc.created_by = userId;
		doc.created = new Date();
		doc.modified_by = userId;
		doc.modified = new Date();

		if doc.password
			doc.password = Steedos.encrypt(doc.password, doc.email, Mail.cryptIvForMail);

	db.mail_accounts.before.update (userId, doc, fieldNames, modifier, options) ->
		email = doc.email;
		modifier.$set.modified_by = userId;
		modifier.$set.modified = new Date();

		if modifier.$set.email
			email = modifier.$set.email

		if modifier.$set.password
			modifier.$set.password = Steedos.encrypt(modifier.$set.password, email, Mail.cryptIvForMail);

	db.mail_accounts.after.findOne (userId, selector, options, doc)->
		if doc?.password
			doc.password = Steedos.decrypt(doc.password, doc.email, Mail.cryptIvForMail)

# db.mail_accounts.after.find (userId, selector, options, cursor)->
# 	cursor.forEach (item) ->
# 		item.password = mailDecrypt.decrypt(item.password, item.email)

if Meteor.isServer
    db.mail_accounts._ensureIndex({
        "owner": 1
    },{background: true})