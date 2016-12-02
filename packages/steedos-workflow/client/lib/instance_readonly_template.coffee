InstanceReadOnlyTemplate = {};

InstanceReadOnlyTemplate.afSelectUser = """
	<div readonly name="{{name}}" id="{{atts.id}}" class="{{atts.class}}" disabled>{{value}}</div>
"""

# TODO 优化获取字段值的方式, 对各种不同类型字段显示进行处理(eg：日期本地化，checkbox值显示)，支持子表字段类型
InstanceReadOnlyTemplate.afFormGroup = """
	<div class='form-group'>
		{{#with getField this.name}}
			{{#if equals type 'section'}}
					<div class='section callout callout-default'>
						<label class="control-label">{{code}}</label>
						<p>{{{description}}}</p>
					</div>
			{{else}}
				<label>{{getLabel code}}</label>
				<div class='form-control' readonly=''>{{getValue code}}</div>
			{{/if}}
		{{/with}}
	</div>
"""


InstanceReadOnlyTemplate.create = (tempalteName, steedosData) ->
	template = InstanceReadOnlyTemplate[tempalteName]

	templateCompiled = SpacebarsCompiler.compile(template, {isBody: true});

	templateRenderFunction = eval(templateCompiled);

	Template[tempalteName] = new Blaze.Template(tempalteName, templateRenderFunction);
	Template[tempalteName].steedosData = steedosData
	Template[tempalteName].helpers InstanceformTemplate.helpers


InstanceReadOnlyTemplate.init = (steedosData) ->
	InstanceReadOnlyTemplate.create("afSelectUser", steedosData);
	InstanceReadOnlyTemplate.create("afFormGroup", steedosData);

#TODO 国际化
InstanceReadOnlyTemplate.getValue = (instance, fields, code) ->
	field = fields.findPropertyByPK("code", code)
	value = instance.values[code];
	switch field.type
		when 'group'
			if field.is_multiselect
				value = instance.values[code]?.getProperty("fullname").toString()
			else
				value = instance.values[code]?.fullname
		when 'user'
			if field.is_multiselect
				value = instance.values[code]?.getProperty("name").toString()
			else
				value = instance.values[code]?.name
		when 'password'
			value = '******'

		when 'checkbox'
			if instance.values[code] && instance.values[code] != 'false'
				value = '是'
			else
				value = '否'

	return value;

InstanceReadOnlyTemplate.getLabel = (fields, code) ->
	field = fields.findPropertyByPK("code", code)

	if field.name
		return field.name
	else
		return field.code

InstanceReadOnlyTemplate.getInstanceFormVersion = (instance)->
	form = db.forms.findOne(instance.form);

	form_version = {}

	form_fields = [];

	if form.current._id == instance.form_version
		form_version = form.current
	else
		form_version = _.where(form.historys, {_id: instance.form_version})[0]

	form_version.fields.forEach (field)->
		if field.type == 'section'
			form_fields.push(field);
			if field.fields
				field.fields.forEach (f) ->
					form_fields.push(f);
		else if field.type == 'table'
			field['sfields'] = field['fields']
			delete field['fields']
		else
			form_fields.push(field);

	form_version.fields = form_fields;

	return form_version;

#Meteor.startup ->
#	if Meteor.isServer
#		InstanceReadOnlyTemplate.init()