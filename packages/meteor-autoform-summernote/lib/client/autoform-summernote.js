AutoForm.addInputType('summernote', {
	template: 'afSummernote',
	valueOut: function() {
		return this.summernote('code');
	}
});
