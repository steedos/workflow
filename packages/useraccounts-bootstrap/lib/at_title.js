// Simply 'inherites' helpers from AccountsTemplates
Template.atTitle.helpers(AccountsTemplates.atTitleHelpers);

Template.atTitle.helpers({
	logo: function() {
		// LOGO文件地址在steedos-theme包中的core.coffee中定义
		if(Steedos){
			var locale = Steedos.locale();
			if (locale === "zh-cn") {
				return Steedos.absoluteUrl(Theme.logo);
			} else {
				return Steedos.absoluteUrl(Theme.logo_en);
			}
		}
		else{
			return Theme.logo;
		}
	}
})