
InstanceReadOnlyTemplate = {};

InstanceReadOnlyTemplate.afSelectUser = "<div>afSelectUser: {{this.name}}--{{this.code}}</div>"

# TODO 优化获取字段值的方式, 对各种不同类型字段显示进行处理(eg：日期本地化，checkbox值显示)，支持子表字段类型
InstanceReadOnlyTemplate.afFormGroup = """
	<div class='form-group'>
		<label>{{this.name}}</label>
		<div class='form-control' readonly=''>{{getValue name}}</div>
	</div>
"""


InstanceReadOnlyTemplate.create = (tempalteName) ->
	template = InstanceReadOnlyTemplate[tempalteName]

	templateCompiled = SpacebarsCompiler.compile(template, { isBody: true });

	templateRenderFunction = eval(templateCompiled);

	Template[tempalteName] = new Blaze.Template(tempalteName, templateRenderFunction);

	Template[tempalteName].helpers InstanceformTemplate.helpers


InstanceReadOnlyTemplate.init = () ->
	InstanceReadOnlyTemplate.create("afSelectUser");
	InstanceReadOnlyTemplate.create("afFormGroup");

Meteor.startup ->
	if Meteor.isServer
		InstanceReadOnlyTemplate.init()