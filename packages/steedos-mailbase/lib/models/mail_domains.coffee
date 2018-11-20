db.mail_domains = new Meteor.Collection('mail_domains')


db.mail_domains._simpleSchema = new SimpleSchema

	domain:
		type: String,
	smtp_server :
		type: String,
	smtp_ssl:
		type: Boolean,
		defaultValue: "false",
	smtp_port:
		type: Number,
		defaultValue: "25",
	imap_server:
		type: String,
	imap_ssl:
		type: Boolean,
		defaultValue: "false",
	imap_port:
		type: Number,
		defaultValue: "143",
	sensitive_keywords_alert:
		type: String
		optional: true,
		autoform:
			type: 'coreform-textarea'
			rows: '6',
	sensitive_keywords_forbidden:
		type: String
		optional: true,
		autoform:
			type: 'coreform-textarea'
			rows: '6',
	before_send:
		type: String
		optional: true,
		autoform:
			type: 'coreform-textarea'
			rows: '6',
	before_save:
		type: String
		optional: true,
		autoform:
			type: 'coreform-textarea'
			rows: '6',

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
	db.mail_domains._simpleSchema.i18n("mail_domains")

db.mail_domains.attachSchema(db.mail_domains._simpleSchema)


#if Meteor.isServer
	#db.mail_domains.after.insert (domain,) ->

if Meteor.isServer
    db.mail_domains._ensureIndex({
        "domain": 1
    },{background: true})