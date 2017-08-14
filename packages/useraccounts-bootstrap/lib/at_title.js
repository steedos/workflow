// Simply 'inherites' helpers from AccountsTemplates
Template.atTitle.helpers(AccountsTemplates.atTitleHelpers);

Template.atTitle.helpers({
	logo: function() {
		return Theme.logo;
	}
})