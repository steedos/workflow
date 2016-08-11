Template.read_mail.helpers
	message: ->
		id = Session.get("mailMessageId");

		return MailManager.getMessage(id) ;
		
	modifiedString: (date)->
	    modifiedString = moment(date).format('YYYY-MM-DD HH:mm');
	    return modifiedString;

   