AutoForm.addInputType("steedosUrl", {
  template: "steedosInputUrl",
  valueConverters: {
    "stringArray": AutoForm.valueConverters.stringToStringArray
  },
  contextAdjust: function (context) {
    if (typeof context.atts.maxlength === "undefined" && typeof context.max === "number") {
      context.atts.maxlength = context.max;
    }
    return context;
  }
});

Template.steedosInputUrl.helpers({
    isReadOnly: function (){
        var atts = this.atts;
        if(atts.hasOwnProperty("disabled") || atts.hasOwnProperty("readonly")){
            return true;
        }
        return false;
    },
    urlValue: function (value) {
        if (value)
            if (value.indexOf("http") == 0)
                return value;
            else
                return "http://" + value;
        else
            return '';
    }
})