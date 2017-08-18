// Simply 'inherites' helpers from AccountsTemplates
Template.atTitle.helpers(AccountsTemplates.atTitleHelpers);

Template.atTitle.helpers({
	logo: function() {
		// LOGO文件地址在steedos-theme包中的core.coffee中定义
		return Theme.logo;
	}
})