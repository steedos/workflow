bootstrap-3-modal
=================
A Meteor package making it easy to use bootstrap 3 modals in Meteor.

**Note 1:** In order for this package to work, you must include bootstrap 3 in
your meteor project. You can add bootstrap 3 to your project by adding the
package `twbs:bootstrap`:

```
meteor add twbs:bootstrap
```

This package does not include `twbs:bootstrap` automatically (in case you
have included bootstrap 3 in another way).

Include this package with:

```
meteor add peppelg:bootstrap-3-modal
```

Usage
-----
To define your own modals, simply define new templates containing your modals
(**important**: your modals must have the class `modal`):

```html
<template name="exampleModal">
	<div class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				
				<div class="modal-header">
					<h4 class="modal-title">Modal example</h4>
				</div>
				
				<div class="modal-body">
					<p>A modal example.</p>
				</div>
				
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
				
			</div>
		</div>
	</div>
</template>
```

Modal templates can be used as ordinary templates in Meteor (`created`,
`helpers`, `rendered`, `events` and `destroyed` all works as you're used to).

No modal is shown (or even inserted into the DOM) by default. By calling
`Modal.show(<templateName>)`, the modal is inserted into the DOM and shown.

```javascript
Meteor.startup(function(){
	// Show the example modal 3 seconds after startup.
	setTimeout(function(){
		Modal.show('exampleModal')
	}, 3000)
})
```

If a second argument is passed to `Modal.show`
(`Modal.show(<templateName>, <dataContext>)`), it will be used as the data
context for the template (works as the `data` parameter for
[Blaze.renderWithData](http://docs.meteor.com/#/full/blaze_renderwithdata)).

Please note that in order to render your data reactively, `<dataContext>` must be a function that returns reactive object:
```javascript
	Modal.show('exampleModal', function () {
		return MyCollection.findOne(itemId);
	});
})
```

A third argument can be passed to `Modal.show`
(`Modal.show(<templateName>, <dataContext>, <modalOptions>)`). It will be used as the `options`
(only) parameter to the modal() call. For example, if you want to disable closing the modal
dialog when the user clicks outside of it, you'd pass

```javascript
{
	backdrop: 'static'
	keyboard: false
}
```

The modal can be removed by calling `Modal.hide()` (or by using the other ways
to remove modals in bootstrap).

Using multiple modals
---------------------
As written in [the documentation for Bootstrap](http://getbootstrap.com/javascript/#modals),
Bootstrap does not support showing multiple modals at a time:

> Overlapping modals not supported

> Be sure not to open a modal while another is still visible. Showing more than one modal at a time requires custom code.

This package does not contain any "custom code" for showing multiple modals at
a time, but it is not limited to only inserting one modal at a time. To enable
insertions of multiple modals, just set `Modal.allowMultiple` to `true`:

```javascript
Modal.allowMultiple = true

Meteor.startup(function(){
	
	// Show the example modal directly on startup...
	Modal.show('exampleModal')
	
	// ...and also 3 seconds later, even if the first one hasn't been closed.
	setTimeout(function(){
		Modal.show('exampleModal')
	}, 3000)
	
})
```

To remove a modal, you need to pass the modal's template instance as
the first argument to `Modal.hide`. Usually, this is done in an event handler,
where the template instance is provided as the second argument.

Examples
--------
At the moment there is one sign up modal and one sign in modal in the directory
`examples`. When a proper way to do this in Meteor (settings min password
length, and things like that) exists in Meteor, I will probably create a
package like accounts-ui, but with modals instead.
