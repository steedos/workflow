getLabel = (code, doc, formula)->
	console.log('run code', code);
	if code.indexOf('.') > -1
		code = code.split('.')[1]
	try
		SelectizeManagerDoc = {}
		SelectizeManagerDoc[code] = _.clone(doc)
		label = eval(formula)
		console.log('run label', label);
		return label
	catch e
		console.log("公式["+formula+"]执行异常：" + e.message);

@SelectizeManager = {
	formatLabel: (code, data, formula)->
		formula = '{_formatLabel} = ' +  formula
		formula = Form_formula.prependPrefixForFormula('SelectizeManagerDoc', formula)
		console.log 'formatLabel formula',formula
		console.log('formatLabel...', data)
		_.each data, (item)->
			label = getLabel(code, item, formula)
			item['@label'] = label
		return data;
}