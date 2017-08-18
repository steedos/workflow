
# 实现定时更新变量
# 在函数中执行Steedos.deps?.miniute?.depend()即可让函数定时执行并更新template
Steedos.deps = {
	miniute: new Tracker.Dependency
};
Meteor.startup ->
	Meteor.setInterval ->
		Steedos.deps.miniute.changed();
	, 600 * 1000

	Tracker.autorun ->
		unless Meteor.userId()
			toastr.clear()