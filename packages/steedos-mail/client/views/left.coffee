Template.layout_left.helpers
    boxNumber: ->
    	console.log("mail_inbox_exists is " + Session.get("mail_inbox_exists"))
    	return Session.get("mail_inbox_exists");

