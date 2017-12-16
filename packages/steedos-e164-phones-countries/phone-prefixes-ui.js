Template.phonePrefixesSelect.helpers({
	prefixes: function(){
		var selectedCode = this.selected;
		if(!selectedCode){
			var tags = navigator.language.match(/-([^-]+)/g);
			if(tags && tags.length){
				selectedCode = tags[tags.length - 1].replace("-","");
			}
			else{
				selectedCode = navigator.language ? navigator.language : "CN";
			}
		}
		var locale = this.locale;
		if(!locale){
			locale = "zh-cn";
		}
		var countries = IsoCountries.getNames(locale);
		var options = []; 
		var props,code,name;
		for(var key in countries){
			props = {};
			code = key;
			prefixe = E164.findPhoneCountryCode(code);
			name = "+" + prefixe + " " + countries[key];
			if (code === selectedCode){
				props = {selected: true};
			}
			options.push({prefixe: prefixe, code: code, name: name, props: props});
		}
		return options;
	}
});

