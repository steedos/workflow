Template.layout_left.helpers
    boxNumber: ->
    	if MailManager
        	return MailManager.getBoxMessageNumber("INBOX");

