Steedos.subsAddressBook = new SubsManager();
Steedos.subs["Organization"] = new SubsManager();

Tracker.autorun (c)->
	if Meteor.userId()
		Steedos.subsAddressBook.subscribe "address_groups";

		Steedos.subsAddressBook.subscribe "address_books";

	if Session.get('contacts_org_mobile')
		Steedos.subs["Organization"].subscribe "organization", Session.get('contacts_org_mobile')

