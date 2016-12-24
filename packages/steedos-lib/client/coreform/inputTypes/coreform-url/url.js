AutoForm.addInputType("steedosUrl", {
  template: "steedosInputUrl",
  valueConverters: {
    "stringArray": AutoForm.valueConverters.stringToStringArray
  },
  contextAdjust: function(context) {
    if (typeof context.atts.maxlength === "undefined" && typeof context.max === "number") {
      context.atts.maxlength = context.max;
    }
    return context;
  }
});

Template.steedosInputUrl.helpers({
  isReadOnly: function() {
    var atts = this.atts;
    if (atts.hasOwnProperty("disabled") || atts.hasOwnProperty("readonly")) {
      return true;
    }
    return false;
  }
})

Template.steedosInputUrl.events({
    'click a':function(event, template){
        if(template.data.value && template.data.value.indexOf("http") != 0){
            event.target.href = "http://" + encodeURI(template.data.value)
        }
    }
})