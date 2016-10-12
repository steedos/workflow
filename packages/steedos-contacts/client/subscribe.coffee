Steedos.subsAddressBook = new SubsManager();

Tracker.autorun (c)->
	if Meteor.userId()
		Steedos.subsAddressBook.subscribe "address_groups";

		Steedos.subsAddressBook.subscribe "address_books";


        