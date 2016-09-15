Template.afSummernote.created = function () {
  this.value = new ReactiveVar(this.data.value);
};

Template.afSummernote.rendered = function() {
  var self = this;
  var options = this.data.atts.settings || {};
  var $editor = $(this.firstNode);
  
  var onblur = options.onblur;
  options.onblur = function(e) {
    $editor.change();
    if (typeof onblur === 'function') {
      onblur.apply(this, arguments);
    }
  };

  $editor.summernote(options);

  this.autorun(function () {
    $editor.summernote('code', self.value.get());
  });

  $editor.closest('form').on('reset', function() {
    $editor.summernote('code', '');
  });
};

Template.afSummernote.helpers({
  atts: function () {
    var self = this;

    /**
     * This is bit hacky but created and rendered callback sometimes
     * (or always?) get empty value. This helper gets called multiple
     * times so we intercept and save the value once it is not empty.
     */
    Tracker.nonreactive(function () {
      var t = Template.instance();
      if (t.value.get() !== self.value) {
        t.value.set(self.value);
      }
    });
    
    return _.omit(this.atts, 'settings');
  }
});