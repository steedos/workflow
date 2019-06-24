Steedos.OdataClient = require('odata-client');
valueOutformat = (val)->
	if val
		_.each _.keys(val), (key)->
			if key.indexOf('.') > -1 || key.startsWith('$')
				delete val[key]
	return val
AutoForm.addInputType "steedos-selectize", {
	template: "afSteedosSelectize"
	valueOut: ()->
		console.log('valueOut', valueOutformat this[0].selectize?.options[this.val()]);
		debugger;
		return valueOutformat this[0].selectize?.options[this.val()]
	valueIn: (val,a,b)->
		console.log('valueIn....', val)
		return val
	contextAdjust:  (context) ->
		context.atts.class = "form-control";
		return context;
}

getCreatorService = (data)->
	return data.url || Meteor.settings.public?.webservices?.creator?.url

getService = (data)->
	spaceId = Steedos.getSpaceId()
	if data.url
		return data.url
	creatorService = getCreatorService(data)
	return Meteor.absoluteUrl("api/odata/v4/#{spaceId}", {rootUrl :creatorService})

getTop = ()->
	return 10

onFocus = ()->
	console.log('onFocus...');

onChange = ()->
	console.log('onChange');

dataFunc = (service, objectName, code, formula, cb)->
	Steedos.OdataClient({
		service: service,
		resources: objectName,
		headers: {
			'X-Auth-Token': Accounts._storedLoginToken(),
			'X-User-Id': Meteor.userId()
		},
		format: 'json'
	}).top(getTop()).get().then (response)->
		data = SelectizeManager.formatLabel(code, JSON.parse(response.body).value, formula);
		cb(data)
#		console.log('response.body', response.body);
#		cb(response.body.value)

Template.afSteedosSelectize.onCreated ()->
	if !getCreatorService(this.data.atts)
		toastr.error('settings.public.webservices.creator.url', 'Missing configuration')
		throw new Meteor.Error("Not find settings.public.webservices.creator.url")
	this.data.atts.class = 'form-control'

Template.afSteedosSelectize.onRendered ()->
	console.log('Template.afSteedosSelectize.onRendered', this);
	key = '@label' || 'name'

	objectName = this.data.atts.related_object
	service = getService(this.data.atts)
	formula = this.data.atts.formula
	code = this.data.atts.name

	value = this.data.value

	console.log('value', value);

	this.selectize = $("##{this.data.atts.id}").selectize {
		valueField: '_id',
		labelField: key,
		searchField: [key],
		options: [],
		create: false,
		maxItems: 1,
		preload: true,
		render: {
			option: (item, escape) ->
				return '<div>' +
					'<span class="title">' +
					'<span class="name">' + escape(item[key]) + '</span>' +
					'</span>' +
					'</div>';
		},
		score: (search) ->
			score = this.getScoreFunction(search);
			return  (item) ->
				return score(item);
		,
		load: (query, callback) ->
			if !this.loaded
				this.loaded = true;
				dataFunc(service, objectName, code, formula, callback);
		,
		onFocus: onFocus,
		onChange: onChange,
	}

	if value
		this.selectize[0].selectize.addOption(value)
		this.selectize[0].selectize.setValue(value._id)

	firstNode = this.view.firstNode()

	$(".selectize-control", firstNode).removeClass("form-control");
	$(".selectize-input", firstNode).addClass("form-control");

	$(".selectize-dropdown", firstNode).removeClass("form-control");

	$(".selectize-dropdown", firstNode).perfectScrollbar();

