AutoForm.addInputType("selectuser", {
    template: "afSelectUser",
    valueIn: function(val, atts) {
        var space = atts.spaceId || true;

        if (atts.spaceId === false) {
            space = false;
        }

        if ("string" == typeof(val)){
			val = val.split(",");

			if(val.length > 0){

				if(atts.multiple != true){
					val = val[0];
				}

				val = CFDataManager.getFormulaSpaceUsers(val, space);
			}
		}

        if (val instanceof Array && val.length > 0 && "string" == typeof(val[0])) {
			if(atts.multiple != true){
				val = val[0];
				val = CFDataManager.getFormulaSpaceUsers(val, space);
			}else{
				val = CFDataManager.getFormulaSpaceUsers(val, space);
			}
        }

        return val;
    },
    valueOut: function() {
        return this[0].dataset.values;
    },
    valueConverters: {
        "stringArray": AutoForm.valueConverters.stringToStringArray,
        "number": AutoForm.valueConverters.stringToNumber,
        "numerArray": AutoForm.valueConverters.stringToNumberArray,
        "boolean": AutoForm.valueConverters.stringToBoolean,
        "booleanArray": AutoForm.valueConverters.stringToBooleanArray,
        "date": AutoForm.valueConverters.stringToDate,
        "dateArray": AutoForm.valueConverters.stringToDateArray
    },
    contextAdjust: function(context) {
        if (typeof context.atts.maxlength === 'undefined' && typeof context.max === 'number') {
            context.atts.maxlength = context.max;
        }

        context.atts.class = "selectUser form-control";

        return context;
    }
});

Template.afSelectUser.helpers({
    val: function(value) {
        if (value) {
            var val = '';
            if (value instanceof Array) { //this.data.atts.multiple && (value instanceof Array)
                if (value.length > 0 && typeof(value[0]) == 'object') {
                    val = value ? value.getProperty("name").toString() : ''
                    this.atts["data-values"] = value ? value.getProperty("id").toString() : '';
                } else {
                    val = value.toString();
                }
            } else {
                if (value && typeof(value) == 'object') {
                    val = value ? value.name : '';
                    this.atts["data-values"] = value ? value.id : '';
                } else {
                    val = value;
                }
            }

            if (this.dataset && "values" in this.dataset) {
                this.atts["data-values"] = this.dataset.values;
            }

            return val;
        }
    }
});


Template.afSelectUser.events({
    'click .selectUser': function(event, template) {
        if (Modal.allowMultiple) {
            return;
        }
        if ("disabled" in template.data.atts)
            return;

        var options = {};

        var dataset = $("input[name='" + template.data.name + "']")[0].dataset;

        if(dataset.error){
			swal({title: dataset.error,confirmButtonText: t("OK")})
        	return ;
		}

        var data, multiple, showOrg = true;

        if (_.isBoolean(template.data.atts.showOrg)) {
            showOrg = template.data.atts.showOrg
        }

        options.userOptions = template.data.atts.userOptions || null

        // options.userOptions = dataset.userOptions || template.data.atts.userOptions || null

        if (dataset.userOptions != undefined && dataset.userOptions != null) {
            options.userOptions = dataset.userOptions;
        }

        if (dataset.multiple) {
            multiple = dataset.multiple == 'true' ? true : false
        } else {
            multiple = template.data.atts.multiple
        }

        if (multiple != true) {
            multiple = false;
        }

        if (dataset.showOrg && dataset.showOrg == 'false') {
            showOrg = false;
        }

        var values = $("input[name='" + template.data.name + "']")[0].dataset.values;

        options.is_within_user_organizations = dataset.is_within_user_organizations || template.data.atts.is_within_user_organizations || false

		options.unselectable_users = template.data.atts.unselectable_users

        if (!_.isBoolean(options.is_within_user_organizations)) {
            if (options.is_within_user_organizations.toLocaleUpperCase() == "TRUE") {
                options.is_within_user_organizations = true
            } else {
                options.is_within_user_organizations = false
            }
        }

        //options.data = data;
        options.multiple = multiple;
        options.showOrg = showOrg;


        if (template.data.atts.spaceId === false) {
            options.spaceId = false
        } else {
            options.spaceId = dataset.spaceId || template.data.atts.spaceId || Session.get("spaceId")
        }


        if (values && values.length > 0) {
            options.defaultValues = values.split(",");
        }

        options.targetId = template.data.atts.id;
        Modal.allowMultiple = true;
        Modal.show("cf_contact_modal", options);
        cssHeightKey = "max-height"
        if (Steedos.isMobile())
            cssHeightKey = "height"
        $(".contacts-modal-body").css(cssHeightKey, Steedos.getModalMaxHeight(20));
    }
});

Template.afSelectUser.rendered = function() {
    var name = this.data.name;
    var dataset = this.data.dataset;
    if (dataset) {
        for (var dk in dataset) {
            $("input[name='" + name + "']")[0].dataset[dk] = dataset[dk]
        }
    }

}